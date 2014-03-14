Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaCNCW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:22:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18898 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaCNCWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:22:24 -0400
X-AuditID: cbfee68f-b7f156d00000276c-35-532267dd6d0f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>, "'Bryan Wu'" <cooloney@gmail.com>
Cc: "'Daniel Jeong'" <gshark.jeong@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1394763240-10176-1-git-send-email-gshark.jeong@gmail.com>
In-reply-to: <1394763240-10176-1-git-send-email-gshark.jeong@gmail.com>
Subject: Re: [PATCH] backlight: lm3639: use devm_backlight_device_register()
Date: Fri, 14 Mar 2014 11:22:21 +0900
Message-id: <000901cf3f2c$3af30630$b0d91290$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8/Kxg/22H4QiDzR2GVRmmrvjSeuAAAMZ/w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zA9176UrBBi9amSyO7pzIZDF5dxer
	xeWFl1gt7n89ymhxou8DkLtrDpvFuocvmCzWz7/F5sDhsXPWXXaPVxfusHjcubaHzaNvyypG
	j+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJWx5P505oL/IhVt+1ayNjBuFOxi5OSQEDCRWHDm
	MDuELSZx4d56ti5GLg4hgWWMEp/3rGaBKToyfzojRGI6o0Tz2ndMEM5vRokvZ3ezgVSxCahJ
	fPkCMUpEwF2icd5DZpAiZoG9TBJ/vq1hAkkICbhJHP/zFmgsBwcnUNGtI2EgprCAj0Tz0TyQ
	ChYBVYlvi/+BVfMK2Ep83zSNBcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wgYyQE1CUe/dWF
	uMBI4tj048wQJSIS+168A7tfQuAvu8S+O8dZIXYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFR
	YhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ6P4djHcPWB9i
	TAZaP5FZSjQ5H5gQ8kriDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QD43yF678+n4o/y6kwP9bu0KZUBbckFVFp2XOvbyZUXpV3evNwRX1bSYL53eYF
	LP8zzzlxzPkusXelnnOA9dzK9VZzrIL2aqtzcq7vrc7bpaonxTd9xryg06WfL71y3Sy3e94u
	BvdnwdGtx6ct10owLZ/GYH4w4qPiXW3lzQYf+N4kNborq3ImKbEUZyQaajEXFScCAIqolfv+	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jQd276UrBBn/PWFkc3TmRyWLy7i5W
	i8sLL7Fa3P96lNHiRN8HIHfXHDaLdQ9fMFmsn3+LzYHDY+esu+wery7cYfG4c20Pm0ffllWM
	HsdvbGfy+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoIiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpL705kL
	/otUtO1bydrAuFGwi5GTQ0LAROLI/OmMELaYxIV769m6GLk4hASmM0o0r33HBOH8ZpT4cnY3
	G0gVm4CaxJcvh9lBbBEBd4nGeQ+ZQYqYBfYySfz5toYJJCEk4CZx/M9bli5GDg5OoKJbR8JA
	TGEBH4nmo3kgFSwCqhLfFv8Dq+YVsJX4vmkaC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5lB
	xkgIqEs8+qsLcYGRxLHpx5khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEp4tnUjsYVzZYHGIU4GBU4uF1OKwYLMSaWFZcmXuIUYKDWUmE
	typCKViINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84GpLK8k3tDYxMzI0sjMwsjE3Jw0YSVx
	3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGDVqOF6xfH64MDtNln/GGaYZrjeevldqF5r2X7M7
	Ifu62N+l07b/4J/IOXHGvjNy+Yyez7Vu2JSFxsy0MBKt1TuolP98Ib+Mes9u597OKcJ5gvXx
	RsYdTL+K/Zkb/vWyrRMLLTCziLafvuno05LtrH932J5/JLNovcH7RxUrVTc2bNeVMFJYrMRS
	nJFoqMVcVJwIAMatd6NbAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 14, 2014 11:14 AM, Daniel Jeong wrote:
> 
>  change to use devm_backlight_device_register() for simple cleanup.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Lee Jones,
Would you merge this patch into your backlight tree?

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/lm3639_bl.c |   17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
> index 6fd60ad..5f36808 100644
> --- a/drivers/video/backlight/lm3639_bl.c
> +++ b/drivers/video/backlight/lm3639_bl.c
> @@ -349,8 +349,9 @@ static int lm3639_probe(struct i2c_client *client,
>  	props.brightness = pdata->init_brt_led;
>  	props.max_brightness = pdata->max_brt_led;
>  	pchip->bled =
> -	    backlight_device_register("lm3639_bled", pchip->dev, pchip,
> -				      &lm3639_bled_ops, &props);
> +	    devm_backlight_device_register(pchip->dev, "lm3639_bled",
> +					   pchip->dev, pchip, &lm3639_bled_ops,
> +					   &props);
>  	if (IS_ERR(pchip->bled)) {
>  		dev_err(&client->dev, "fail : backlight register\n");
>  		ret = PTR_ERR(pchip->bled);
> @@ -360,7 +361,7 @@ static int lm3639_probe(struct i2c_client *client,
>  	ret = device_create_file(&(pchip->bled->dev), &dev_attr_bled_mode);
>  	if (ret < 0) {
>  		dev_err(&client->dev, "failed : add sysfs entries\n");
> -		goto err_bled_mode;
> +		goto err_out;
>  	}
> 
>  	/* flash */
> @@ -391,8 +392,6 @@ err_torch:
>  	led_classdev_unregister(&pchip->cdev_flash);
>  err_flash:
>  	device_remove_file(&(pchip->bled->dev), &dev_attr_bled_mode);
> -err_bled_mode:
> -	backlight_device_unregister(pchip->bled);
>  err_out:
>  	return ret;
>  }
> @@ -407,10 +406,8 @@ static int lm3639_remove(struct i2c_client *client)
>  		led_classdev_unregister(&pchip->cdev_torch);
>  	if (&pchip->cdev_flash)
>  		led_classdev_unregister(&pchip->cdev_flash);
> -	if (pchip->bled) {
> +	if (pchip->bled)
>  		device_remove_file(&(pchip->bled->dev), &dev_attr_bled_mode);
> -		backlight_device_unregister(pchip->bled);
> -	}
>  	return 0;
>  }
> 
> @@ -432,6 +429,6 @@ static struct i2c_driver lm3639_i2c_driver = {
>  module_i2c_driver(lm3639_i2c_driver);
> 
>  MODULE_DESCRIPTION("Texas Instruments Backlight+Flash LED driver for LM3639");
> -MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
> -MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
> +MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
> +MODULE_AUTHOR("Ldd Mlp <ldd-mlp@list.ti.com>");
>  MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5

