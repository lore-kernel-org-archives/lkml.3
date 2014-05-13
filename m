Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbaEMBgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:36:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59123 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaEMBgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:36:52 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ea-53717732d300
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: "'Tony Lindgren'" <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Alexandre Courbot'" <gnurou@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140509012454.GL2198@atomide.com>
In-reply-to: <20140509012454.GL2198@atomide.com>
Subject: Re: [PATCH] backlight: gpio-backlight: Fix warning when the GPIO is on
 a I2C chip
Date: Tue, 13 May 2014 10:36:49 +0900
Message-id: <000001cf6e4b$cf668a00$6e339e00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9rKQIYYi6bhmLERjilPDCc5OfwiwDIkeiw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zka5ReWGwwcM5zBZHd05ksjj36hGL
	xeWFl1gt7n89ymgx5c9yJosTfR9YLS7vmsNmMXtJP4vF7cu8FusevmCyWD//FpvF/iteDjwe
	Lc09bB7fvk5i8dg56y67x6sLd1g87lzbw+bRt2UVo8fxG9uZPD5vkgvgiOKySUnNySxLLdK3
	S+DKOLvzL0vBG9GK/fMPsDcwfhPqYuTkkBAwkfgw5TwbhC0mceHeeiCbi0NIYBmjxJRf69lh
	ip6sbGeHSCxilHixppsVwvnNKHGkdw9YO5uAmsSXL4fBOkSA7Jt7ZjGBFDELbGaWmPZuKxNI
	QkhAX+LJuhZGEJtTwEDi5Zm/QHEODmGBGImXa91BwiwCqhIP7x5iBbF5BWwlfuydxQJhC0r8
	mHwPzGYW0JJYv/M4E4QtL7F5zVtmkDESAuoSj/7qQpxgJLH0+gqochGJfS/eMYKcIyGwlEPi
	3ZLVLBC7BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYk
	FxQnpRcZ6xUn5haX5qXrJefnbmKEpIL+HYx3D1gfYkwGWj+RWUo0OR+YSvJK4g2NzYwsTE1M
	jY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6MfU4RwvPWeSnH2TW1T
	Zu+qWX0q5S2j6A/XbPUbGt+E+a7Ve13cyJ8YZ8KhqMa+cpWNx+/Khx2XYsPa9rQKH1tfYRub
	a6AROO3CsplyApYZAsfqFphMdd3XvkNITfk6d1q6+1YpubufGpT1lnktT3G20Jmz8bzAK8/8
	c6+mbH2lOXnzqpsLzyixFGckGmoxFxUnAgAKey2RGwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAV3D8sJgg9O91hZHd05ksjj36hGL
	xeWFl1gt7n89ymgx5c9yJosTfR9YLS7vmsNmMXtJP4vF7cu8FusevmCyWD//FpvF/iteDjwe
	Lc09bB7fvk5i8dg56y67x6sLd1g87lzbw+bRt2UVo8fxG9uZPD5vkgvgiGpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulZJoSwxpxQoFJBYXKyk
	b4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHF251+WgjeiFfvnH2BvYPwm1MXIySEhYCLxZGU7
	O4QtJnHh3nq2LkYuDiGBRYwSL9Z0s0I4vxkljvTuYQOpYhNQk/jy5TBYhwiQfXPPLCaQImaB
	zcwS095tZQJJCAnoSzxZ18IIYnMKGEi8PPMXKM7BISwQI/FyrTtImEVAVeLh3UOsIDavgK3E
	j72zWCBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMMkZCQF3i0V9diBOMJJZeXwFVLiKx78U7
	xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM40TyT3sG4
	qsHiEKMAB6MSD++CZwXBQqyJZcWVuYcYJTiYlUR4e4oLg4V4UxIrq1KL8uOLSnNSiw8xJgM9
	OpFZSjQ5H5gE80riDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	sfHFzhjOprZLHWFTlFUPKFx+wjOd7ea/1ct0ykKORrPo3wl3uTO/Rtd/3a9ZTzaKX3yXrP3b
	96N+4NHfpT2/jmoszHL680zjUsLniWU8DYJzDFY/SG7mVGFO+fHyl2Nty2e5dpkG+3lPZ113
	z5j0tmXPyht/Ql9HTnZ9Var0UnuiRnOT8AypDUosxRmJhlrMRcWJAPbbfSB4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 10:25 AM, Tony Lindgren wrote:
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
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>

(+cc Linus Walleij, Alexandre Courbot, Russell King)

Hi Lee Jones,

Would you apply this patch into backlight git tree?
If you have other opinions, please let us know. :-)
Thank you.

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

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

