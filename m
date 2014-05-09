Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaEIDmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:42:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46887 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaEIDmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:42:10 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-7f-536c4e90b131
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tony Lindgren'" <tony@atomide.com>
Cc: "'Lee Jones'" <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Alexandre Courbot'" <gnurou@gmail.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20140509012454.GL2198@atomide.com>
 <004701cf6b2d$e1a39c10$a4ead430$%han@samsung.com>
 <20140509030925.GN2198@atomide.com>
In-reply-to: <20140509030925.GN2198@atomide.com>
Subject: Re: [PATCH] backlight: gpio-backlight: Fix warning when the GPIO is on
 a I2C chip
Date: Fri, 09 May 2014 12:42:07 +0900
Message-id: <000001cf6b38$a6a3ffa0$f3ebfee0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9rNL9cLiDLr4oiQamgV6t71uoCaQAAfp3g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zvu4Ev5xgg86VUhZHd05ksjj36hGL
	xeWFl1gt7n89ymgx5c9yJosTfR9YLS7vmsNmMXtJP4vF7cu8FusevmCyWD//FpvF/iteDjwe
	Lc09bB7fvk5i8dg56y67x6sLd1g87lzbw+bRt2UVo8fxG9uZPD5vkgvgiOKySUnNySxLLdK3
	S+DK+LDxMEvBS8WKtf1tLA2MN6S7GDk5JARMJG78Os4MYYtJXLi3nq2LkYtDSGAZo8Tq7muM
	MEV7nq1lgUhMZ5RoeLETrENI4DejxO6lfiA2m4CaxJcvh9lBbBEgu3fRDGaQBmaBzcwSzdc7
	GSG6Oxklnl2fxAJSxSlgIHFs72WgDg4OYYEYiZdr3UHCLAKqEk+ut4Nt5hWwlfjy/Sc7hC0o
	8WPyPbBWZgEtifU7jzNB2PISm9e8ZQYZIyGgLvHory7EDUYSHbvvQpWLSOx78Q7sBAmBpRwS
	1y8fYYfYJSDxbfIhFoheWYlNB6AhISlxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFy
	QXFSepGhXnFibnFpXrpecn7uJkZIKujdwXj7gPUhxmSg9ROZpUST84GpJK8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGBsl4+Z/PvLgyTZX95/l
	Pgfz9/H/U10k/pJBbNmVDlke20+ql/suXDp84exHFT/G+pdxz06rvWrsYmTbc0w5PsJyq9eL
	3i99DqLOKl9c07pXb+WMqdk5J1ljcmDFsYCbqzoche+vrf9veZ49evPSm7NCTptmn5TffZDp
	YZjMD9+3L9/KfSlzt1ZiKc5INNRiLipOBAAWye8BGwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jQd1+v5xgg/0t2hZHd05ksjj36hGL
	xeWFl1gt7n89ymgx5c9yJosTfR9YLS7vmsNmMXtJP4vF7cu8FusevmCyWD//FpvF/iteDjwe
	Lc09bB7fvk5i8dg56y67x6sLd1g87lzbw+bRt2UVo8fxG9uZPD5vkgvgiGpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulZJoSwxpxQoFJBYXKyk
	b4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFh42GWgpeKFWv721gaGG9IdzFyckgImEjsebaW
	BcIWk7hwbz1bFyMXh5DAdEaJhhc7mUESQgK/GSV2L/UDsdkE1CS+fDnMDmKLANm9i2YwgzQw
	C2xmlmi+3skI0d3JKPHs+iSwsZwCBhLH9l4G6uDgEBaIkXi51h0kzCKgKvHkejsjiM0rYCvx
	5ftPdghbUOLH5HtgrcwCWhLrdx5ngrDlJTavecsMMkZCQF3i0V9diBuMJDp234UqF5HY9+Id
	4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcaJ5J72Bc
	1WBxiFGAg1GJh/fFlOxgIdbEsuLK3EOMEhzMSiK8pb45wUK8KYmVValF+fFFpTmpxYcYk4Ee
	ncgsJZqcD0yCeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	6HsjlDNHY0Mtw+9b/sGP2uSUupWt5CbYfFI9qfshJ47JsyNV/NNkzqc94SVnJFpfzvv671/d
	OhUfD++tLmrCh3zeZf08nyZR5aVTPpEh+YHZhDl2Wc8Dl56ZduqumZ00R5XM3Bs3PRYfNTpY
	whVSxa3MFX1tu/LG3Oz8hI7H9/bE6fw/q/ldiaU4I9FQi7moOBEAyLICpHgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 12:09 PM, Tony Lindgren wrote:
> On Friday, May 09, 2014 11:25 AM, Jingoo Han wrote:
> > On Friday, May 09, 2014 10:25 AM, Lee Jones wrote:
> > >
> > > If the GPIO for the backlight is on an I2C chip, we currently
> > > get nasty warnings like this during the boot:
> > >
> > > WARNING: CPU: 0 PID: 6 at drivers/gpio/gpiolib.c:2364 gpiod_set_raw_value+0x40/0x4c()
> > > Modules linked in:
> > > CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.15.0-rc4-12393-gcde9f4e #400
> > > Workqueue: deferwq deferred_probe_work_func
> > > [<c0014cbc>] (unwind_backtrace) from [<c001191c>] (show_stack+0x10/0x14)
> > > [<c001191c>] (show_stack) from [<c0566ae0>] (dump_stack+0x80/0x9c)
> > > [<c0566ae0>] (dump_stack) from [<c003f61c>] (warn_slowpath_common+0x68/0x8c)
> > > [<c003f61c>] (warn_slowpath_common) from [<c003f65c>] (warn_slowpath_null+0x1c/0x24)
> > > [<c003f65c>] (warn_slowpath_null) from [<c02f7e10>] (gpiod_set_raw_value+0x40/0x4c)
> > > [<c02f7e10>] (gpiod_set_raw_value) from [<c0308fbc>] (gpio_backlight_update_status+0x4c/0x74)
> > > [<c0308fbc>] (gpio_backlight_update_status) from [<c030914c>] (gpio_backlight_probe+0x168/0x254)
> > > [<c030914c>] (gpio_backlight_probe) from [<c0378fa8>] (platform_drv_probe+0x18/0x48)
> > > [<c0378fa8>] (platform_drv_probe) from [<c0377c40>] (driver_probe_device+0x10c/0x238)
> > > [<c0377c40>] (driver_probe_device) from [<c0376330>] (bus_for_each_drv+0x44/0x8c)
> > > [<c0376330>] (bus_for_each_drv) from [<c0377afc>] (device_attach+0x74/0x8c)
> > > [<c0377afc>] (device_attach) from [<c03771c4>] (bus_probe_device+0x88/0xb0)
> > > [<c03771c4>] (bus_probe_device) from [<c03775c8>] (deferred_probe_work_func+0x64/0x94)
> > > [<c03775c8>] (deferred_probe_work_func) from [<c00572e8>] (process_one_work+0x1b4/0x4bc)
> > > [<c00572e8>] (process_one_work) from [<c00579d0>] (worker_thread+0x11c/0x398)
> > > [<c00579d0>] (worker_thread) from [<c005dfd8>] (kthread+0xc8/0xe4)
> > > [<c005dfd8>] (kthread) from [<c000e768>] (ret_from_fork+0x14/0x2c)
> > >
> > > Fix this by using gpio_set_value_cansleep() as suggested in
> > > drivers/gpio/gpiolib.c:2364. This is what the other backlight drivers
> > > are also doing.
> >
> > OK, I see.
> > However, gpio_backlight drive can be used by a lot of gpio drivers.
> > In some cases, 'can_sleep' is 'false' and gpio_set_value_cansleep()
> > is unnecessary.
> >
> > In my opinion, gpio_set_value_cansleep() or gpio_set_value() can be
> > called selectively by 'can_sleep' value.
> >
> > How about the following?
> >
> > -       gpio_set_value(gbl->gpio, brightness ? gbl->active : !gbl->active);
> > +       if (gpio_cansleep(gbl->gpio))
> > +               gpio_set_value_cansleep(gbl->gpio,
> > +                                       brightness ? gbl->active : !gbl->active);
> > +       else
> > +               gpio_set_value(gbl->gpio, brightness ? gbl->active : !gbl->active);
> 
> It should be always fine to use gpio_set_value_cansleep(), see your
> old thread from few years ago related to another backlight driver:
> 
> https://lkml.org/lkml/2012/12/5/343

(+cc Linus Walleij, Alexandre Courbot, Russell King)

OK, I see.

gpio_set_value_cansleep() calls gpiod_set_raw_value_cansleep(),
and gpio_set_value() calls gpiod_set_raw_value() as below.

./drivers/gpio/gpiolib.c
void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value)
{
        might_sleep_if(extra_checks);
        if (!desc)
                return;
        _gpiod_set_raw_value(desc, value);
}
EXPORT_SYMBOL_GPL(gpiod_set_raw_value_cansleep);

./drivers/gpio/gpiolib.c
void gpiod_set_raw_value(struct gpio_desc *desc, int value)
{
        if (!desc)
                return;
        /* Should be using gpio_set_value_cansleep() */
        WARN_ON(desc->chip->can_sleep);
        _gpiod_set_raw_value(desc, value);
}
EXPORT_SYMBOL_GPL(gpiod_set_raw_value);

Then, the difference between gpio_set_value_cansleep() or
gpio_set_value() is whether might_sleep_if(extra_checks) is
called or not.

So, you said that "It should be always fine to use 
gpio_set_value_cansleep()", right?

Linus Walleij,
Is there any reason to keep these two functions such as
gpiod_set_raw_value_cansleep() and gpiod_set_raw_value()?

Best regards,
Jingoo Han

