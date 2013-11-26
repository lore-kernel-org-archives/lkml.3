Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3KZE1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:27:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56762 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KZE1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:27:12 -0500
X-AuditID: cbfee691-b7f666d0000048b0-54-5294231fee77
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Kay Sievers'" <kay@vrfy.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131112033906.GA30454@july>
In-reply-to: <20131112033906.GA30454@july>
Subject: Re: [PATCH v2] video: backlight: Remove backlight sysfs uevent
Date: Tue, 26 Nov 2013 13:27:11 +0900
Message-id: <001001ceea5f$c6642e50$532c8af0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7fWLLJJ5g8UvCZScqyHwCOo0hhJQLBrPQg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zA1155SlBBm0TlS3mrF/DZnF54SVW
	i1urnrNb3Lq8isXiRN8HVovLu+awWeze9ZTVgd1j8wotjxMzfrN47Jn/g9Wjb8sqRo/Pm+Q8
	Pq73DGCL4rJJSc3JLEst0rdL4Mrof9rLVLCYt2LnQtsGxs9cXYwcHBICJhKn1gd0MXICmWIS
	F+6tZ+ti5OIQEljGKPHw0FUWiISJxNqWB+wQiUWMEjuvbIRyfjFKTGvZxwhSxSagJvHly2F2
	kKkiAvoSbS0aIDXMApcZJXoX7WIHqRES0JRY+mg3I0gNp4CWxKTvmSBhYQF3iff3T7CC2CwC
	qhJLZ55gA7F5BWwl+pf9ZIewBSV+TL4HdhAzUOv6nceZIGx5ic1r3jJDPKMu8eivLkhYRMBI
	YvGDr6wQJSIS+168YwQ5R0LgK7vElZ0/mSF2CUh8m3yIBaJXVmLTAWaIfyUlDq64wTKBUWIW
	ks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIid+JOxjvH7A+xJgM
	tH4is5Rocj4w/vNK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgVFN8FB02b5sT+XXEwIYq6a7z1I+0GmzZe7B36lTGm9ICc26bl1kuDjiz/GEL5Xn
	g4KEj39deLknWd0nf2pGu+6CK70HAy7fZ50imaAxo9Lg/oVDH5J/XmBetqxfmE38suRdy8gf
	/TnKllbO3v6B3HqfzJTsd7xfHn9T7gvHxNt7cg/fqLCW1FRiKc5INNRiLipOBADGtF4n9QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAV155SlBBl8eyVnMWb+GzeLywkus
	FrdWPWe3uHV5FYvFib4PrBaXd81hs9i96ymrA7vH5hVaHidm/Gbx2DP/B6tH35ZVjB6fN8l5
	fFzvGcAW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0ipJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo/9pL1PBYt6KnQtt
	Gxg/c3UxcnJICJhIrG15wA5hi0lcuLeerYuRi0NIYBGjxM4rG9khnF+MEtNa9jGCVLEJqEl8
	+XIYKMHBISKgL9HWogFSwyxwmVGid9EusElCApoSSx/tZgSp4RTQkpj0PRMkLCzgLvH+/glW
	EJtFQFVi6cwTbCA2r4CtRP+yn+wQtqDEj8n3WEBsZqDW9TuPM0HY8hKb17xlBhkpIaAu8eiv
	LkhYRMBIYvGDr6wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGC08MzqR2MKxssDjEKcDAq8fBKdE4OEmJNLCuuzD3EKMHBrCTC63ofKMSb
	klhZlVqUH19UmpNafIgxGejRicxSosn5wNSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MOSJ8/Hs2/j17O+D/gWPzhdd2/fj+SDNDne/VTtag0oqyrPVH
	q/STZk85K1KT+i6qxP/LUin30M8vU6udjDnKF33Rnbpy0yW9mv3sB0W+hmTVRu0RLF5bob7n
	NMePwsUz1Ffsqf5sOsecTa0tVPbPEYlJzIqblM/4ZeZFbNq6RN/4k/r8p5tnKbEUZyQaajEX
	FScCANj6j55TAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 12, 2013 12:39 PM, Kyungmin Park wrote:
>
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
> It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
> 
> Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes
> about 5ms. The main problem is that it hurts other process activities. so remove it.
> 
> Kay said
> "Uevents are for the major, low-frequent, global device state-changes,
>  not for carrying-out any sort of measurement data. Subsystems which
>  need that should use other facilities like poll()-able sysfs file or
>  any other subscription-based, client-tracking interface which does not
>  cause overhead if it isn't used. Uevents are not the right thing to
>  use here, and upstream udev should not paper-over broken kernel
>  subsystems."
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> v1: there's still user to use BACKLIGHT_UPDATE_SYSFS. so just remove store sysfs node uevent
> 
> ---
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 94a403a..292cf99 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -172,8 +172,6 @@ static ssize_t brightness_store(struct device *dev,
>  	}
>  	mutex_unlock(&bd->ops_lock);
> 
> -	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
> -
>  	return rc;
>  }
>  static DEVICE_ATTR_RW(brightness);

