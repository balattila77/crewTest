<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ItemRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        /**
         * there is a bug in date or date_format with dates of February 2017
         * working on it.... 
         */
        return [
            "name" => 'required|max:100',
            "description" => 'required',
            "slug" => 'required|unique:items|max:100',
            "added" => 'required',
            "manufacturer" => 'required|max:100',
            "productImg" => 'required|max:50'
        ];
    }
}
