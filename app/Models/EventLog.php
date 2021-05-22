<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * App\Models\EventLog
 *
 * @property int $id
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog query()
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog whereUpdatedAt($value)
 * @mixin \Eloquent
 * @property int $job_id
 * @property int $item_id
 * @property string $event_status
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog whereEventStatus($value)
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog whereItemId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|EventLog whereJobId($value)
 */
class EventLog extends Model
{
    use HasFactory;

    protected $guarded = [];
}
