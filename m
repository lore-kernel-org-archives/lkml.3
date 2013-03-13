Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3CMAdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:33:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39033 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3CMAda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:33:30 -0400
X-AuditID: cbfee68e-b7f946d000001e37-a8-513fc957c5be
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003d01ce1ee5$316a57c0$943f0740$%han@samsung.com>
 <513F7BD2.5040800@metafoo.de>
In-reply-to: <513F7BD2.5040800@metafoo.de>
Subject: Re: [PATCH] backlight: da903x_bl: switch to using SIMPLE_DEV_PM_OPS
Date: Wed, 13 Mar 2013 09:33:26 +0900
Message-id: <00b201ce1f82$60a775c0$21f66140$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4fU/E3rXn98lAWT+aOi6xo8D+HbwALjLSA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY93wk/aBBlOuclrMWb+GzeLywkus
	Fksmz2e1uLxrDpvF7l1PWR1YPU7M+M3iseTNIVaPPfN/sHr0bVnF6PF5k1wAaxSXTUpqTmZZ
	apG+XQJXxmSgEQUdwhUHltQ0MO7m72Lk5JAQMJHofD+dHcIWk7hwbz1bFyMXh5DAMkaJNRf2
	ssMU3b7wlQUiMZ1R4urpbijnF6PEh5vzwKrYBNQkvnw5DGaLCGhJTP32lhWkiFlgCaPEnJef
	GEESQgKxEp3fOsCKOIGKrl+8BDSJg0NYwEeieTNYmEVAVeLA6acsIDavgK3EpEUH2SBsQYkf
	k++BxZmBWtfvPM4EYctLbF7zlhlkjISAusSjv7oQJxhJTG5+zwpRIiKx78U7RpBzJASusUvc
	vjaDCWKXgMS3yYdYIHplJTYdYIZ4WFLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILk
	guKk9CIjveLE3OLSvHS95PzcTYyQSO3bwXjzgPUhxmSg9ROZpUST84GRnlcSb2hsZmRhamJq
	bGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxqpfUVXlz7avnKWSftDZ
	aO+MXBO9n+suzTDl3hOgqDJlf13Wwxc17WWead/yhJK4ov/0TGtbuSS4aFnkJeFYn//TOau9
	mwoU+hOmJRz1zJFbc+Mqk3jEZZ0Kte2mpzln9h7Xnxse/TU3/uRNmTiNOW8vbvksutfhtuMM
	tsy8vXamE2XmzNy4UomlOCPRUIu5qDgRANo6oAbqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3wk/aBBosOs1jMWb+GzeLywkus
	Fksmz2e1uLxrDpvF7l1PWR1YPU7M+M3iseTNIVaPPfN/sHr0bVnF6PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8ZkoNMLOoQrDiypaWDczd/FyMkhIWAicfvC
	VxYIW0ziwr31bF2MXBxCAtMZJa6e7maBcH4xSny4OY8dpIpNQE3iy5fDYLaIgJbE1G9vWUGK
	mAWWMErMefmJESQhJBAr0fmtA6yIE6jo+sVLQJM4OIQFfCSaN4OFWQRUJQ6cfgq2mVfAVmLS
	ooNsELagxI/J98DizECt63ceZ4Kw5SU2r3nLDDJGQkBd4tFfXYgTjCQmN79nhSgRkdj34h3j
	BEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwGnknvYFzV
	YHGIUYCDUYmHVyLNPlCINbGsuDL3EKMEB7OSCK/2BqAQb0piZVVqUX58UWlOavEhxmSgRycy
	S4km5wNTVF5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MGq8
	aPc6fn39/olc+em/nVg/neto7yoIrv5ee7g5l//8n69zI335/51nPlTAseSzlnxd3Tfp+vmV
	Lc9ita6tOvb12JrZ/E6mIm+EZ5TPWummpbdhS7XM7SOpJXM/LVcLrfVIvRmx85TXiTKPfwVb
	d881UNa3m9DqaCeV0e/5qJvJLFFx9UwhPyWW4oxEQy3mouJEAI5ehhxHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 13, 2013 4:03 AM, Lars-Peter Clausen wrote:
> 
> On 03/12/2013 06:48 AM, Jingoo Han wrote:
> > This reduces #ifdefs in the code. Also, CONFIG_PM_SLEEP is used
> > to avoid warnings of unused functions if CONFIG_PM_SLEEP is not
> > defined.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> I think you can eliminate the suspend/resume functions all together by using
> the blacklight subsystems CORE_SUSPENDRESUME feature.

Hi Lars-Peter Clausen,

Yes, you're right.
I will use CORE_SUSPENDRESUME feature.
Thank you for your comment :)

Best regards,
Jingoo Han

> 
> E.g.
> 
> diff --git a/drivers/video/backlight/da903x_bl.c
> b/drivers/video/backlight/da903x_bl.c
> index 8179cef..80ba6b3 100644
> --- a/drivers/video/backlight/da903x_bl.c
> +++ b/drivers/video/backlight/da903x_bl.c
> @@ -88,6 +88,9 @@ static int da903x_backlight_update_status(struct
>  	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
>  		brightness = 0;
> 
> +	if (bl->props.state & BL_CORE_SUSPENDED)
> +		brightness = 0;
> +
>  	return da903x_backlight_set(bl, brightness);
>  }
> 
> @@ -100,6 +103,7 @@ static int da903x_backlight_get_brightness(struct
>  static const struct backlight_ops da903x_backlight_ops = {
>  	.update_status	= da903x_backlight_update_status,
>  	.get_brightness	= da903x_backlight_get_brightness,
> +	.options	= BL_CORE_SUSPENDRESUME,
>  };
> 
>  static int da903x_backlight_probe(struct platform_device *pdev)
> @@ -161,35 +165,10 @@ static int da903x_backlight_remove(struct
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PM
> -static int da903x_backlight_suspend(struct device *dev)
> -{
> -	struct backlight_device *bl = dev_get_drvdata(dev);
> -
> -	return da903x_backlight_set(bl, 0);
> -}
> -
> -static int da903x_backlight_resume(struct device *dev)
> -{
> -	struct backlight_device *bl = dev_get_drvdata(dev);
> -
> -	backlight_update_status(bl);
> -	return 0;
> -}
> -
> -static const struct dev_pm_ops da903x_backlight_pm_ops = {
> -	.suspend	= da903x_backlight_suspend,
> -	.resume		= da903x_backlight_resume,
> -};
> -#endif
> -
>  static struct platform_driver da903x_backlight_driver = {
>  	.driver		= {
>  		.name	= "da903x-backlight",
>  		.owner	= THIS_MODULE,
> -#ifdef CONFIG_PM
> -		.pm	= &da903x_backlight_pm_ops,
> -#endif
>  	},
>  	.probe		= da903x_backlight_probe,
>  	.remove		= da903x_backlight_remove,

