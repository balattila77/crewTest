<?php

namespace App\Providers;

use Illuminate\Support\Facades\Queue;
use Illuminate\Queue\Events\JobProcessed;
use Illuminate\Queue\Events\JobProcessing;
use Illuminate\Queue\Events\JobFailed;
use Illuminate\Support\ServiceProvider;
use App\Models\EventLog;
use Log;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Queue::before(function (JobProcessing $event) {
            EventLog::create([
                'item_id' => unserialize($event->job->payload()['data']['command'])->item->id,
                'job_id' => $event->job->getJobId(),
                'event_status' => 'attempted'
            ]);
        });

        Queue::after(function (JobProcessed $event) {
            //
        });

        Queue::failing(function (JobFailed $event) {
            EventLog::create([
                'item_id' => unserialize($event->job->payload()['data']['command'])->item->id,
                'job_id' => $event->job->getJobId(),
                'event_status' => 'failed'
            ]);
        });
    }
}
