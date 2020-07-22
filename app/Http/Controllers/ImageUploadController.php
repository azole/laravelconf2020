<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Image;

class ImageUploadController extends Controller
{
    public function upload(Request $request)
    {
        $image = new Image;

        $image->name = time() . '.' .  $request->image->extension();
        $image->path = '/storage/' . $request->file('image')->storeAs('images', $image->name, 'public');

        $image->save();

        return back()
            ->with('success', '上傳成功')
            ->with('image', $image->path);
    }
}
