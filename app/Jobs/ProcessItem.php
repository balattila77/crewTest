<?php

namespace App\Jobs;

use App\Models\Item;
use App\Models\EventLog;
use Exception;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Log;

class ProcessItem implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $tries = 3;
    

    public $item;
    
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct(Item $item)
    {
        $this->item = $item;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {        
        if ($this->mustFail($this->getTotalAttempts())) {
            $this->failTheJob();
        } else {
            $this->processTheJob();
        }
    }

    private function failTheJob()
    {
        Log::info('Item ' . $this->item->slug . ' FAILED');
        EventLog::create([
            'item_id' => unserialize($this->job->payload()['data']['command'])->item->id,
            'job_id' => $this->job->getJobId(),
            'event_status' => 'fake failed'
        ]);
        throw new Exception('Fake error');
    }

    private function processTheJob()
    {
        $this->item->processed = 'true';
        $this->item->save();
        Log::info('Item ' . $this->item->slug . ' processed');
        EventLog::create([
            'item_id' => unserialize($this->job->payload()['data']['command'])->item->id,
            'job_id' => $this->job->getJobId(),
            'event_status' => 'processed'
        ]);
    }

    public function mustFail($totalAttempts)
    {
        if (($totalAttempts + 1) % 3 === 0) {
            return true;
        }
        return false;
    }

    private function getTotalAttempts()
    {
        return EventLog::where('event_status', 'attempted')->count();
    }
}
