Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3GYBvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:51:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39069 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3GYBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:51:51 -0400
X-AuditID: cbfee68f-b7f436d000000f81-05-51f084b65bba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-28-git-send-email-gregkh@linuxfoundation.org>
In-reply-to: <1374703539-9705-28-git-send-email-gregkh@linuxfoundation.org>
Subject: Re: [PATCH 27/36] video: backlight: convert class code to use
 dev_groups
Date: Thu, 25 Jul 2013 10:51:49 +0900
Message-id: <000601ce88d9$874219e0$95c64da0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHmmxXO7mceqhZGJB2ibqCJPHJ2SgH5ito0mTSwWtA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI91tLR8CDY68YLdoXryezeLywkus
	Fpd3zWGz2L3rKasDi8f+uWvYPfbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmbPrex
	F+zTqHj1cgJ7A+MuxS5GDg4JAROJhiuZXYycQKaYxIV769m6GLk4hASWMUrcet3GDlOztF8a
	pEZIYBGjxMqXfBA1vxglXlzazQqSYBNQk/jy5TA7iC0iECrxf3czWJxZwEvi1+Fj7BANXYwS
	T0+/A0twCnhLrNy2hhnEFhYIllh/8D4jiM0ioCqxaEo3G4jNK2Ap8e7oDihbUOLH5HssEEO1
	JNbvPM4EYctLbF7zlhniAwWJHWdfM0IcYSXxZssfqBoRiX0v3jFC1Jxil2hfEwKxS0Di2+RD
	LBBPykpsOgA1RlLi4IobLBMYJWYh2TwLyeZZSDbPQrJhASPLKkbR1ILkguKk9CJjveLE3OLS
	vHS95PzcTYyQmOzfwXj3gPUhxmSg9ROZpUST84ExnVcSb2hsZmRhamJqbGRuaUaasJI4r1qL
	daCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRoXrBxIVNGyPbsh4kHDq/Fb/t3Xc7P1Cq87+
	0jzxb/+rWnMrxUM85eW7rVQVqoN+xrwunv01NuLy4rq9igfqMrg+3GDJXVW7Lqjm8OV8iYCK
	V3MW7hK4vviSeolR3xKlZDPnLR6iW5at/ym/J+rLWluvv29kHxyVFzkdut7ENXZxeoizv5v1
	bCWW4oxEQy3mouJEACGmkmjfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd1tLR8CDZ7OZ7ZoXryezeLywkus
	Fpd3zWGz2L3rKasDi8f+uWvYPfbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZmz63sRfs06h49XICewPjLsUuRg4OCQETiaX90l2MnECmmMSF
	e+vZQGwhgUWMEitf8nUxcgHZvxglXlzazQqSYBNQk/jy5TA7iC0iECrxf3czWJxZwEvi1+Fj
	7BANXYwST0+/A0twCnhLrNy2hhnEFhYIllh/8D4jiM0ioCqxaEo32DZeAUuJd0d3QNmCEj8m
	32OBGKolsX7ncSYIW15i85q3zBCXKkjsOPuaEeIIK4k3W/5A1YhI7HvxjnECo9AsJKNmIRk1
	C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvpnUjsYVzZYHGIU4GBU4uFd
	8f19oBBrYllxZe4hRgkOZiUR3tiKD4FCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9MSHkl
	8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFh1ddaS9ywTslIL
	LS3qb+0/dG6Z/aTSiIw5fKdSX+hvdjwbGPzq9KFj3HXpuuckUmU3CkqdZdZnN2Twi49yOS+4
	/+idoLDc2DZusbZjZQybRI651hVoVAp3njnWeH+Jh9/it5ViUy3+/pr8WOr9SUZp6VCB/vP2
	x7+EM7VlXt7NILOedYLeMiWW4oxEQy3mouJEAHyi7lM+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 25, 2013 7:06 AM, Greg Kroah-Hartman wrote:
> 
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the video backlight class code to
> use the correct field.
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Richard, feel free to take this through your tree, or ACK it and I can
> take it through mine.

Hi Greg Kroah-Hartman,

I hope that it will go through your tree with my Ack.

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han


> 
>  drivers/video/backlight/backlight.c | 44 ++++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 3fccb6d3..94a403a9 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -103,16 +103,16 @@ static void backlight_generate_event(struct backlight_device *bd,
>  	sysfs_notify(&bd->dev.kobj, NULL, "actual_brightness");
>  }
> 
> -static ssize_t backlight_show_power(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> +static ssize_t bl_power_show(struct device *dev, struct device_attribute *attr,
> +		char *buf)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> 
>  	return sprintf(buf, "%d\n", bd->props.power);
>  }
> 
> -static ssize_t backlight_store_power(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t count)
> +static ssize_t bl_power_store(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
>  {
>  	int rc;
>  	struct backlight_device *bd = to_backlight_device(dev);
> @@ -136,8 +136,9 @@ static ssize_t backlight_store_power(struct device *dev,
> 
>  	return rc;
>  }
> +static DEVICE_ATTR_RW(bl_power);
> 
> -static ssize_t backlight_show_brightness(struct device *dev,
> +static ssize_t brightness_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> @@ -145,7 +146,7 @@ static ssize_t backlight_show_brightness(struct device *dev,
>  	return sprintf(buf, "%d\n", bd->props.brightness);
>  }
> 
> -static ssize_t backlight_store_brightness(struct device *dev,
> +static ssize_t brightness_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	int rc;
> @@ -175,24 +176,27 @@ static ssize_t backlight_store_brightness(struct device *dev,
> 
>  	return rc;
>  }
> +static DEVICE_ATTR_RW(brightness);
> 
> -static ssize_t backlight_show_type(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> +static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> +		char *buf)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> 
>  	return sprintf(buf, "%s\n", backlight_types[bd->props.type]);
>  }
> +static DEVICE_ATTR_RO(type);
> 
> -static ssize_t backlight_show_max_brightness(struct device *dev,
> +static ssize_t max_brightness_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
> 
>  	return sprintf(buf, "%d\n", bd->props.max_brightness);
>  }
> +static DEVICE_ATTR_RO(max_brightness);
> 
> -static ssize_t backlight_show_actual_brightness(struct device *dev,
> +static ssize_t actual_brightness_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	int rc = -ENXIO;
> @@ -205,6 +209,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
> 
>  	return rc;
>  }
> +static DEVICE_ATTR_RO(actual_brightness);
> 
>  static struct class *backlight_class;
> 
> @@ -247,16 +252,15 @@ static void bl_device_release(struct device *dev)
>  	kfree(bd);
>  }
> 
> -static struct device_attribute bl_device_attributes[] = {
> -	__ATTR(bl_power, 0644, backlight_show_power, backlight_store_power),
> -	__ATTR(brightness, 0644, backlight_show_brightness,
> -		     backlight_store_brightness),
> -	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
> -		     NULL),
> -	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
> -	__ATTR(type, 0444, backlight_show_type, NULL),
> -	__ATTR_NULL,
> +static struct attribute *bl_device_attrs[] = {
> +	&dev_attr_bl_power.attr,
> +	&dev_attr_brightness.attr,
> +	&dev_attr_actual_brightness.attr,
> +	&dev_attr_max_brightness.attr,
> +	&dev_attr_type.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(bl_device);
> 
>  /**
>   * backlight_force_update - tell the backlight subsystem that hardware state
> @@ -493,7 +497,7 @@ static int __init backlight_class_init(void)
>  		return PTR_ERR(backlight_class);
>  	}
> 
> -	backlight_class->dev_attrs = bl_device_attributes;
> +	backlight_class->dev_groups = bl_device_groups;
>  	backlight_class->pm = &backlight_class_dev_pm_ops;
>  	return 0;
>  }
> --
> 1.8.3.rc0.20.gb99dd2e

