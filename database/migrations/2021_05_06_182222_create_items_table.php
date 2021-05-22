<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateItemsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('items', function (Blueprint $table) {
            $table->id();
            $table->decimal('price', 6, 2);
            $table->char('name', 100);
            $table->text('description');
            $table->char('slug', 100);
            $table->datetime('added');
            $table->char('manufacturer', 100);
            $table->char('itemType', 20);
            $table->char('productImg', 50);
            $table->char('processed', 5)->default('false');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('items');
    }
}
