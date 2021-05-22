<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\ItemRequest;
use App\Models\Item;
use App\Models\Job;
use App\Models\EventLog;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Http\Client\Pool;
use Illuminate\Support\Facades\Http;
use App\Jobs\ProcessItem;
use Log;

class StockController extends Controller
{
    
    
    public function index()
    {
        Log::info('statByYearMonth query processed'); 
        return Item::selectRaw('year(added) year, monthname(added) month, count(*) uploads')
                ->groupBy('year', 'month')
                ->orderBy('year', 'desc')
                ->get();
    }

    public function store(ItemRequest $request)
    {
        Log::info('API store process called');  
        $dataToStore = $request->only('price', 'name', 'description', 'slug', 'manufacturer', 'itemType', 'productImg', 'added');        
        $jobId = $this->storeItem($dataToStore);
        return response(["slug" => $request->slug, "jobId" => $jobId], Response::HTTP_CREATED);
    }
    
    public function storeBulk(Request $request)
    {
        Log::info('API bulk-store process called'); 
        $responses = [];
        $json = file_get_contents($request->jsonFile);
        $bulkData = json_decode($json, true);     
        
        foreach ($bulkData as $dataToStore) {
            $jobId = $this->storeItem($dataToStore);
            if($jobId){
                $responses[] = ["slug" => $dataToStore['slug'], "jobId" => $jobId];
            }
        }
            
        return response($responses, Response::HTTP_CREATED);
    }

    public function storeItem($dataToStore)
    {
        Log::info($dataToStore['slug'] . ' save process started');
        if (!$this->isExistsItem($dataToStore['slug'])) {                        
            $item = Item::create([
                'price' => $dataToStore['price'],
                'name' => $dataToStore['name'],
                'description' => $dataToStore['description'],
                'slug' => $dataToStore['slug'],
                'added' => $this->convertJsTimestampToDateTime($dataToStore['added']),
                'manufacturer' => $dataToStore['manufacturer'],
                'itemType' => $dataToStore['itemType'],
                'productImg' => $dataToStore['productImg']
            ]);
            Log::info($dataToStore['slug'] . ' item saved, id: ' . $item->id);
            ProcessItem::dispatch($item);
            $jobId = Job::orderBy('id', 'desc')->first('id');   
            Log::info($dataToStore['slug'] . ' item process queued, job id: ' . $jobId->id);  
            EventLog::create([
                'item_id' => $item->id,
                'job_id' => $jobId->id,
                'event_status' => 'queued'
            ]);       
            return $jobId;
        }  else {
            Log::info($dataToStore['slug'] . ' already exists save process stopped');
        }      
        return null;
    }
   
    private function isExistsItem($slug)
    {
        return Item::where('slug', $slug)->first('id');
    }

    private function convertJsTimestampToDateTime($timestamp){
        return date('Y-m-d H:i:s', round($timestamp / 1000));
    }

    
    public function show($id)
    {
        //
    }

    
    public function update(Request $request, $id)
    {
        //
    }

    
    public function destroy($id)
    {
        //
    }
}
