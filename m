Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaATBer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 20:34:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50847 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaATBeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 20:34:44 -0500
X-AuditID: cbfee690-b7f266d00000287c-ba-52dc7d31581d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Shuah Khan'" <shuah.kh@samsung.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Shuah Khan'" <shuahkhan@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
 <15798389.lgk83XnI1i@vostro.rjw.lan>
In-reply-to: <15798389.lgk83XnI1i@vostro.rjw.lan>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Mon, 20 Jan 2014 10:34:41 +0900
Message-id: <001f01cf157f$ca2e8530$5e8b8f90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8VKlvMHfDoMCbLT9iidy8H1/7uiQAVEgGA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zka5h7Z0gg/nHrS06Z15jtLi88BKr
	xYm+D6wWl3fNYbNY9/AFk8XjFW/ZLc6cBkrs3vWU1eLLZy6Lrz8dLNbPv8XmwO2xc9Zddo8P
	H+M8Fu95yeTx6sIdFo8tV9tZPPbM/8Hq0bdlFaPH8RvbmTw+b5IL4IzisklJzcksSy3St0vg
	yrg27zx7wSqRipYTm1gaGA8IdDFyckgImEhMb9jLBmGLSVy4tx7I5uIQEljGKDF96242mKI7
	ZxawQiQWMUq8ajzFDOH8Aqpa/pMVpIpNQE3iy5fD7CC2iECIxKSfLxlBipgFOpkljjy+zQSS
	EBLIkmiY1gk2llPAUOLu1PvMILawgLdEx5k1YDUsAqoSK/48ZAGxeQVsJRbc28gEYQtK/Jh8
	DyjOATRUXWLKlFyQMLOAvMTmNW+ZQcISQOFHf3UhTjCSmP3gHiNEiYjEvhfvGCGeWcghseyx
	AsQmAYlvkw+xQLTKSmw6wAxRIilxcMUNlgmMErOQ7J2FsHcWkr2zkCxYwMiyilE0tSC5oDgp
	vchErzgxt7g0L10vOT93EyMkCUzYwXjvgPUhxmSg7ROZpUST84FJJK8k3tDYzMjC1MTU2Mjc
	0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDv6/Fa0JL3Oqdt9v2fvqnyu
	bX8KPIWP/OE2+/kr03nzl3Sr8O6dSav/mrhp2ydOW3JMfkFibE2kOeuDRmdzyVfLlu9icte8
	X6OU9O7c9AUvf3VLej90WS/jvik00/aiz8bGHcXHBY1bO088L3m550zMjgjpUwe7HgopfzS+
	Z1NfnF0d/2j/LiWW4oxEQy3mouJEAG7gKjIYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAV3D2jtBBv8Xm1l0zrzGaHF54SVW
	ixN9H1gtLu+aw2ax7uELJovHK96yW5w5DZTYvespq8WXz1wWX386WKyff4vNgdtj56y77B4f
	PsZ5LN7zksnj1YU7LB5brrazeOyZ/4PVo2/LKkaP4ze2M3l83iQXwBnVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SskkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj2rzz7AWrRCpaTmxiaWA8INDFyMkhIWAicefMAlYI
	W0ziwr31bF2MXBxCAosYJV41nmKGcH4xSkxf/hOsik1ATeLLl8PsILaIQIjEpJ8vGUGKmAU6
	mSWOPL7NBJIQEsiSaJjWyQZicwoYStydep8ZxBYW8JboOLMGrIZFQFVixZ+HLCA2r4CtxIJ7
	G5kgbEGJH5PvAcU5gIaqS0yZkgsSZhaQl9i85i0zSFgCKPzory7ECUYSsx/cY4QoEZHY9+Id
	4wRGoVlIBs1CGDQLyaBZSDoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOMs+kdjCu
	bLA4xCjAwajEw2vgdidIiDWxrLgy9xCjBAezkghvfwVQiDclsbIqtSg/vqg0J7X4EGMy0JsT
	maVEk/OBCTCvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhi1
	3M8n6v4NclEX/WgsfWC5yJFKr4pzNTeWOH2J+yWruHPWeuet8ZoTGrLueufW+DD72DteOzkv
	zlLqsJe68/x/Ka2agZ0prlbR0vXiW0puBHt/2+OgPtNzzjvJ7PP1TXERBx4Fc1eJpkwpsZiQ
	IFgZJ/3U6MH2yTMmJHFOW6jyb8LqBtn3t5RYijMSDbWYi4oTAavQe+52AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 20, 2014 12:37 AM, Rafael J. Wysocki wrote:
> On Wednesday, November 14, 2040 04:27:17 AM Shuah Khan wrote:
> > Convert drivers/video/backlight/class to use dev_pm_ops for power
> > management and remove Legacy PM ops hooks. With this change, rtc class
> > registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
> > Legacy class->suspend/resume. When __device_suspend() runs call-backs,
> > it will find class->pm ops for the backlight class.
> >
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > Cc: Shuah Khan <shuahkhan@gmail.com>
> 
> Can you please resend the patches that nobody took with CCs to
> linux-pm@vger.kernel.org?  If the original maintainers don't care, I'll be
> able to pick those patches up then (if they look good).

I already gave the comment, and am waiting v3 patch.
However, Shuah Khan did not send the v3 patch yet.

Currently, backlight subsystem patches go through mm-tree
With my acked-by.

Shuah Khan,
Will you send the v3 patch? As I said, there is the typo in
commit message. Please fix it. 
   s/rtc class/backlight class

Best regards,
Jingoo Han

> > ---
> >
> > v2: Updated changelog to correct device class.
> >
> >  drivers/video/backlight/backlight.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> > index c74e7aa..0ffb251 100644
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -208,7 +208,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
> >
> >  static struct class *backlight_class;
> >
> > -static int backlight_suspend(struct device *dev, pm_message_t state)
> > +static int backlight_suspend(struct device *dev)
> >  {
> >  	struct backlight_device *bd = to_backlight_device(dev);
> >
> > @@ -236,6 +236,9 @@ static int backlight_resume(struct device *dev)
> >  	return 0;
> >  }
> >
> > +static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
> > +			 backlight_resume);
> > +
> >  static void bl_device_release(struct device *dev)
> >  {
> >  	struct backlight_device *bd = to_backlight_device(dev);
> > @@ -414,8 +417,7 @@ static int __init backlight_class_init(void)
> >  	}
> >
> >  	backlight_class->dev_attrs = bl_device_attributes;
> > -	backlight_class->suspend = backlight_suspend;
> > -	backlight_class->resume = backlight_resume;
> > +	backlight_class->pm = &backlight_class_dev_pm_ops;
> >  	return 0;
> >  }
> >
> >

