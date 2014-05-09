Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaEICZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:25:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16623 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaEICZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:25:05 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-ec-536c3c7ea753
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tony Lindgren'" <tony@atomide.com>
Cc: "'Lee Jones'" <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140509012454.GL2198@atomide.com>
In-reply-to: <20140509012454.GL2198@atomide.com>
Subject: Re: [PATCH] backlight: gpio-backlight: Fix warning when the GPIO is on
 a I2C chip
Date: Fri, 09 May 2014 11:25:01 +0900
Message-id: <004701cf6b2d$e1a39c10$a4ead430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9rJt5TfKiwEDkDS/iwMbK3nzGUeQABAHIw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY906m5xgg+2bhSyO7pzIZHF54SVW
	i/tfjzJanOj7wGpxedccNovZS/pZLNY9fMFksX7+LTaL/Ve8HDg9vn2dxOKxc9Zddo9XF+6w
	eNy5tofNo2/LKkaP4ze2M3l83iQXwB7FZZOSmpNZllqkb5fAlbF98Vm2gqmSFYdaXjE2MM4X
	7WLk4JAQMJHY+dyqi5ETyBSTuHBvPVsXIxeHkMAyRomujf/YIBImEsvWLmSHSCxilJj8uYsJ
	wvnNKHGrZTEzSBWbgJrEly+H2UFsESC7d9EMZpAiZoENTBKHzmwHSwgJ6Es8WdfCCGJzChhI
	vDzzlwnkDGGBGImXa91BwiwCqhL3P0xlBQnzCthKHFtfAxLmFRCU+DH5HguIzSygJbF+53Em
	CFteYvOat8wQz6hLPPqrC3GBkcTCHzOgSkQk9r14xwjxSy+HxLkOXYhNAhLfJh9igWiVldh0
	gBmiRFLi4IobLBMYJWYhWTwLyeJZSBbPQrJhASPLKkbR1ILkguKk9CITveLE3OLSvHS95Pzc
	TYyQ+J6wg/HeAetDjMlA6ycyS4km5wPTQ15JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MKpbs+lPXv6lKNfq3DnXW1Xrux71lbDouxdoTOQ+tEf4
	ZMnW19ciGmLYS2du/c12Vk/29I/Cefd9RQz/p7w3iLwxMcBHbM3cMIm1b7bk3zxTc+TM7kmf
	k36ZTdn3e+MRd7VJbI951+2Jlvv88aai652O8zYyR+5UCR35PrVG9tmmS4b7rKoa/r1WYinO
	SDTUYi4qTgQAYZ1oqwUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jAd06m5xgg4bnPBZHd05ksri88BKr
	xf2vRxktTvR9YLW4vGsOm8XsJf0sFusevmCyWD//FpvF/iteDpwe375OYvHYOesuu8erC3dY
	PO5c28Pm0bdlFaPH8RvbmTw+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1
	tLQwV1LIS8xNtVVy8QnQdcvMATpNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYx5ixffFZtoKpkhWHWl4xNjDOF+1i5OSQEDCRWLZ2ITuELSZx4d56ti5GLg4hgUWMEpM/
	dzFBOL8ZJW61LGYGqWITUJP48uUwWIcIkN27aAYzSBGzwAYmiUNntoMlhAT0JZ6sa2EEsTkF
	DCRenvkLNImDQ1ggRuLlWneQMIuAqsT9D1NZQcK8ArYSx9bXgIR5BQQlfky+xwJiMwtoSazf
	eZwJwpaX2LzmLTNIuYSAusSjv7oQFxhJLPwxA6pERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKA
	kWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnACeSa1g3Flg8UhRgEORiUe3hdTsoOFWBPL
	iitzDzFKcDArifDe0c8JFuJNSaysSi3Kjy8qzUktPsSYDPTnRGYp0eR8YHLLK4k3NDYxM7I0
	MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGzZkB7Narzmwq+nAg4OmxE0t6
	f+z/zXTZ+i5HlazPRa6cKqvSqzfKH5efT3j1taBI4HuVxR+z9LbLWq9qJqvw5M9MWXZdxbX3
	UFb6TDH1azWTrhw10DUwybiqkzDF5Vb3ep6N+1paGgJWfD+WsfjePUuVTray6vfhP8SuL7Q4
	u0nf6ZWe8rrHSizFGYmGWsxFxYkAoSQW7GQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 10:25 AM, Lee Jones wrote:
> 
> If the GPIO for the backlight is on an I2C chip, we currently
> get nasty warnings like this during the boot:
> 
> WARNING: CPU: 0 PID: 6 at drivers/gpio/gpiolib.c:2364 gpiod_set_raw_value+0x40/0x4c()
> Modules linked in:
> CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.15.0-rc4-12393-gcde9f4e #400
> Workqueue: deferwq deferred_probe_work_func
> [<c0014cbc>] (unwind_backtrace) from [<c001191c>] (show_stack+0x10/0x14)
> [<c001191c>] (show_stack) from [<c0566ae0>] (dump_stack+0x80/0x9c)
> [<c0566ae0>] (dump_stack) from [<c003f61c>] (warn_slowpath_common+0x68/0x8c)
> [<c003f61c>] (warn_slowpath_common) from [<c003f65c>] (warn_slowpath_null+0x1c/0x24)
> [<c003f65c>] (warn_slowpath_null) from [<c02f7e10>] (gpiod_set_raw_value+0x40/0x4c)
> [<c02f7e10>] (gpiod_set_raw_value) from [<c0308fbc>] (gpio_backlight_update_status+0x4c/0x74)
> [<c0308fbc>] (gpio_backlight_update_status) from [<c030914c>] (gpio_backlight_probe+0x168/0x254)
> [<c030914c>] (gpio_backlight_probe) from [<c0378fa8>] (platform_drv_probe+0x18/0x48)
> [<c0378fa8>] (platform_drv_probe) from [<c0377c40>] (driver_probe_device+0x10c/0x238)
> [<c0377c40>] (driver_probe_device) from [<c0376330>] (bus_for_each_drv+0x44/0x8c)
> [<c0376330>] (bus_for_each_drv) from [<c0377afc>] (device_attach+0x74/0x8c)
> [<c0377afc>] (device_attach) from [<c03771c4>] (bus_probe_device+0x88/0xb0)
> [<c03771c4>] (bus_probe_device) from [<c03775c8>] (deferred_probe_work_func+0x64/0x94)
> [<c03775c8>] (deferred_probe_work_func) from [<c00572e8>] (process_one_work+0x1b4/0x4bc)
> [<c00572e8>] (process_one_work) from [<c00579d0>] (worker_thread+0x11c/0x398)
> [<c00579d0>] (worker_thread) from [<c005dfd8>] (kthread+0xc8/0xe4)
> [<c005dfd8>] (kthread) from [<c000e768>] (ret_from_fork+0x14/0x2c)
> 
> Fix this by using gpio_set_value_cansleep() as suggested in
> drivers/gpio/gpiolib.c:2364. This is what the other backlight drivers
> are also doing.

OK, I see.
However, gpio_backlight drive can be used by a lot of gpio drivers.
In some cases, 'can_sleep' is 'false' and gpio_set_value_cansleep()
is unnecessary.

In my opinion, gpio_set_value_cansleep() or gpio_set_value() can be
called selectively by 'can_sleep' value.

How about the following?

-       gpio_set_value(gbl->gpio, brightness ? gbl->active : !gbl->active);
+       if (gpio_cansleep(gbl->gpio))
+               gpio_set_value_cansleep(gbl->gpio,
+                                       brightness ? gbl->active : !gbl->active);
+       else
+               gpio_set_value(gbl->gpio, brightness ? gbl->active : !gbl->active);

Best regards,
Jingoo Han

> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> --- a/drivers/video/backlight/gpio_backlight.c
> +++ b/drivers/video/backlight/gpio_backlight.c
> @@ -38,7 +38,8 @@ static int gpio_backlight_update_status(struct backlight_device *bl)
>  	    bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
>  		brightness = 0;
> 
> -	gpio_set_value(gbl->gpio, brightness ? gbl->active : !gbl->active);
> +	gpio_set_value_cansleep(gbl->gpio,
> +				brightness ? gbl->active : !gbl->active);
> 
>  	return 0;
>  }
> --

