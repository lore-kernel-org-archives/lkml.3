Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbbACBEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 20:04:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36753 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbACBEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 20:04:08 -0500
X-AuditID: cbfee691-f79b86d000004a5a-13-54a7400510c7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Aaron Lu'" <aaron.lu@intel.com>
Cc: "'Lee Jones'" <lee.jones@linaro.org>, "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1419997818-19528-1-git-send-email-aaron.lu@intel.com>
 <1419997818-19528-2-git-send-email-aaron.lu@intel.com>
In-reply-to: <1419997818-19528-2-git-send-email-aaron.lu@intel.com>
Subject: Re: [PATCH 1/3] video / backlight: add two APIs for drivers to use
Date: Sat, 03 Jan 2015 10:04:40 +0900
Message-id: <000b01d026f1$408e3620$c1aaa260$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAkrO81VT/w+L9dQS+o4FqxnghNNgCRC14w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zA11Wh+UhBk/3ylps6vvNZnF54SVW
	i/tfjzJaLN/Xz2hxedccNovPvUcYLc6cBko8edjH5sDhsXjPSyaPO9f2sHlsudrO4tG3ZRWj
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZTd8PMxfcl6+Y83QmYwNjn1QXIyeHhICJxMK+U+wQtpjE
	hXvr2boYuTiEBJYxSjw7d4AJpuj2nJdQiemMEu09k6GcX4wSyx5dYgWpYhNQk/jy5TDYKBEB
	ZYnNr64xgRQxC3xilLhw/gwzSEJIoFriz4weMJtTwFliz9XPLCC2sIC3xL7Js4GmcnCwCKhK
	PP0fA2LyCthK3L7nA1LBKyAo8WPyPbBqZgEtifU7jzNB2PISm9e8ZQYplxBQl3j0VxfiAiOJ
	y71rWCFKRCT2vXjHCPHLV3aJFy8zQGwWAQGJb5MPsUC0ykpsOsAMUSIpcXDFDZYJjBKzkCye
	hWTxLCSLZyHZsICRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSBRP3MF4/4D1IUYBDkYl
	Hl4Oi+UhQqyJZcWVuYcYTYEumsgsJZqcD0wVeSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1ME5Lyk7cMaXpROU+y017NojO42TlX/Wm0jt6S+7eQxzu
	2+682aS53v3uvczcvWJaKz99T7npJhutsWV1iOxdca4v2g9L/IRt6/aIX75Qe2NFcBCblRWD
	0uM6K6GVK+esYS5lPaLdFrlkvW3yo1SfsHuXl+1QTPh37rzk5DO5E49tir1vslyfRVCJpTgj
	0VCLuag4EQA0fOzF3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQV1Wh+UhBq96JSw29f1ms7i88BKr
	xf2vRxktlu/rZ7S4vGsOm8Xn3iOMFmdOAyWePOxjc+DwWLznJZPHnWt72Dy2XG1n8ejbsorR
	4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23
	zBygY5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGU3fDzMX3JevmPN0
	JmMDY59UFyMnh4SAicTtOS/ZIGwxiQv31gPZXBxCAtMZJdp7JkM5vxgllj26xApSxSagJvHl
	y2F2EFtEQFli86trTCBFzAKfGCUunD/DDJIQEqiW+DOjB8zmFHCW2HP1MwuILSzgLbFv8myg
	qRwcLAKqEk//x4CYvAK2Erfv+YBU8AoISvyYfA+smllAS2L9zuNMELa8xOY1b5lByiUE1CUe
	/dWFuMBI4nLvGlaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBSeKZ9A7GVQ0WhxgFOBiVeHgTrJaHCLEmlhVX5h5ilOBgVhLhZdm7LESI
	NyWxsiq1KD++qDQntfgQoynQmxOZpUST84EJLK8k3tDYxMzI0sjMwsjE3FxJnFfJvi1ESCA9
	sSQ1OzW1ILUIpo+Jg1OqgTE6Lcwg9u/00u1Mzkvmhb1029T/5vP6bBNL1ZlcUkc439d8dHLR
	2uT15ed5ZZUlr0UzmGXt1mvI3Ug9u7qudouIoCPvi8MPtL685tz0TnrpxNf68j+qotY88/Ti
	+dk9OXEbq1Gw6hwOvskP77w44Obe7O0xffLxFvv1iybtuVMX5Xt/6ZnwWRxKLMUZiYZazEXF
	iQD3y7mTKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 31, 2014 12:50 PM, Aaron Lu wrote:
> 
> It is useful to get the backlight device's pointer and use it to set
> backlight in some cases(the following patch will make use of it) so add
> the two APIs and export them.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/backlight.c | 44 ++++++++++++++++++++++++-------------
>  include/linux/backlight.h           |  2 ++
>  2 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index bddc8b17a4d8..bea749329236 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -164,28 +164,19 @@ static ssize_t brightness_show(struct device *dev,
>  	return sprintf(buf, "%d\n", bd->props.brightness);
>  }
> 
> -static ssize_t brightness_store(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> +int backlight_device_set_brightness(struct backlight_device *bd, int brightness)
>  {
> -	int rc;
> -	struct backlight_device *bd = to_backlight_device(dev);
> -	unsigned long brightness;
> -
> -	rc = kstrtoul(buf, 0, &brightness);
> -	if (rc)
> -		return rc;
> -
> -	rc = -ENXIO;
> +	int rc = -ENXIO;
> 
>  	mutex_lock(&bd->ops_lock);
>  	if (bd->ops) {
>  		if (brightness > bd->props.max_brightness)
>  			rc = -EINVAL;
>  		else {
> -			pr_debug("set brightness to %lu\n", brightness);
> +			pr_debug("set brightness to %u\n", brightness);
>  			bd->props.brightness = brightness;
>  			backlight_update_status(bd);
> -			rc = count;
> +			rc = 0;
>  		}
>  	}
>  	mutex_unlock(&bd->ops_lock);
> @@ -194,6 +185,23 @@ static ssize_t brightness_store(struct device *dev,
> 
>  	return rc;
>  }
> +EXPORT_SYMBOL(backlight_device_set_brightness);
> +
> +static ssize_t brightness_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	int rc;
> +	struct backlight_device *bd = to_backlight_device(dev);
> +	unsigned long brightness;
> +
> +	rc = kstrtoul(buf, 0, &brightness);
> +	if (rc)
> +		return rc;
> +
> +	rc = backlight_device_set_brightness(bd, brightness);
> +
> +	return rc ? rc : count;
> +}
>  static DEVICE_ATTR_RW(brightness);
> 
>  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> @@ -380,7 +388,7 @@ struct backlight_device *backlight_device_register(const char *name,
>  }
>  EXPORT_SYMBOL(backlight_device_register);
> 
> -bool backlight_device_registered(enum backlight_type type)
> +struct backlight_device *backlight_device_get_by_type(enum backlight_type type)
>  {
>  	bool found = false;
>  	struct backlight_device *bd;
> @@ -394,7 +402,13 @@ bool backlight_device_registered(enum backlight_type type)
>  	}
>  	mutex_unlock(&backlight_dev_list_mutex);
> 
> -	return found;
> +	return found ? bd : NULL;
> +}
> +EXPORT_SYMBOL(backlight_device_get_by_type);
> +
> +bool backlight_device_registered(enum backlight_type type)
> +{
> +	return backlight_device_get_by_type(type) ? true : false;
>  }
>  EXPORT_SYMBOL(backlight_device_registered);
> 
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index adb14a8616df..c59a020df3f8 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -140,6 +140,8 @@ extern void backlight_force_update(struct backlight_device *bd,
>  extern bool backlight_device_registered(enum backlight_type type);
>  extern int backlight_register_notifier(struct notifier_block *nb);
>  extern int backlight_unregister_notifier(struct notifier_block *nb);
> +extern struct backlight_device *backlight_device_get_by_type(enum backlight_type type);
> +extern int backlight_device_set_brightness(struct backlight_device *bd, int brightness);
> 
>  #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
> 
> --
> 2.1.0

