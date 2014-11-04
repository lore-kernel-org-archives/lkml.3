Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaKDKSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:18:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61027 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaKDKSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:18:30 -0500
X-AuditID: cbfee68d-f79296d000004278-83-5458a7f47327
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>,
        "=?utf-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <50522512.UJWUZtqLop@diego> <20141103171731.GH12011@x1>
 <20141104090754.GG17577@x1>
In-reply-to: <20141104090754.GG17577@x1>
Subject: Re: [PATCH] backlight: use of_find_backlight_by_node stub when
 backlight class disabled
Date: Tue, 04 Nov 2014 19:18:59 +0900
Message-id: <001101cff818$bfe149b0$3fa3dd10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/4DtVetSCfP/LrQL21IMANyUWKXQACRCxg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zI90vyyNCDGbcULY4unMik8X/R69Z
	LS4vvMRqcf/rUUaLy7vmsDmweuycdZfd4861PWwefVtWMXpsvzaP2ePzJrkA1igum5TUnMyy
	1CJ9uwSujCu3P7EULBOqaDi7hLGB8QJfFyMnh4SAicTbHwtYIGwxiQv31rN1MXJxCAksY5SY
	/2staxcjB1jRjf/KIDVCAtMZJdY06kDU/GKUePb3OjNIgk1ATeLLl8PsILaIQIzE50Xv2UBs
	ZoF0iQkPVzNBNCdK9D9bDbaMU0BDYvPh14wgtrBAksTVU7dZQWwWAVWJBRt/gNXzCthKLGr9
	wQhhC0r8mHyPBeQeZgF1iSlTciHGa0s8eXcB6kx1iUd/dSEuMJKYfnYDM0SJiMS+F+8YQU6W
	ELjFLvGqrYkRYpWAxLfJh1ggemUlNh1ghgSDpMTBFTdYJjBKzEKyeBbC4llIFs9CsmEBI8sq
	RtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJAY7d3BePuA9SFGAQ5GJR7eCMmIECHWxLLiytxD
	jKZAB01klhJNzgcmgrySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhh5fSVYegIUJ7A9cahS81ZKWvtfU2T2Gd7Py+6+7vQ7O8fPvH713mcnl+RyWNYq
	xBw/vN7gsXzFl107JZr+RwvP8ZR2yPucuFd4y9Mz21MqLgrN/Tyrdv7txXzLtvdv2Bz91uVY
	w5QTjLacrZsb4g+WWwbMq1w5tfB9ya+mwsonO+8WFrT7LdigxFKckWioxVxUnAgArMPamcwC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoO6X5REhBhf2y1sc3TmRyeL/o9es
	FpcXXmK1uP/1KKPF5V1z2BxYPXbOusvucefaHjaPvi2rGD22X5vH7PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aV259YCpYJVTScXcLYwHiBr4uRg0NCwETi
	xn/lLkZOIFNM4sK99WwgtpDAdEaJNY06XYxcQPYvRolnf68zgyTYBNQkvnw5zA5iiwjESHxe
	9B6sgVkgXWLCw9VMEM2JEv3PVrOA2JwCGhKbD79mBLGFBZIkrp66zQpiswioSizY+AOsnlfA
	VmJR6w9GCFtQ4sfkeywgtzELqEtMmZILMV5b4sm7C6wQJ6tLPPqrC3GBkcT0sxuYIUpEJPa9
	eMc4gVFoFpJBsxAGzUIyaBaSjgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxghPAM6kd
	jCsbLA4xCnAwKvHwRkhGhAixJpYVV+YeYpTgYFYS4V1dBRTiTUmsrEotyo8vKs1JLT7EaAr0
	5kRmKdHkfGByyiuJNzQ2MTOyNDKzMDIxN1cS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwNg7
	++Ot7y9/13f+01SWYS+1EOJxeVT24VCc6/qLCyRidF0jzffw9yXIHnt1J0HF6suVcon3c3fu
	EvqSa+8stPXm0Yf3fsz4MmdVY7zZbYn2xw/NT5xlen88n5d/4n3ZvUk7dsQt5LQr5EvptTDd
	9M1vRW3L221Ckvyr2w42fQ06+/GM+in/3CglluKMREMt5qLiRABG0zYbFgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 6:08 PM, Heiko Stübner wrote:
> On Mon, 03 Nov 2014, Lee Jones wrote:
> 
> > On Wed, 29 Oct 2014, Heiko Stübner wrote:
> >
> > > Drivers may want to search for an optional backlight even when the backlight
> > > class is disabled. In this case the linker would miss the function referenced
> > > in the backlight header.
> > >
> > > Therefore use the stub function also when the backlight class is disabled.
> > >
> > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > > ---
> > >  include/linux/backlight.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Applied to Backlight -next with Jingoo's Ack.
> 
> I've removed this patch, as it causes unexpected:
> 
>   Redefinition of of_find_backlight_by_node()

I reproduced the same build error.

Then, how about folding the following two patches into
one single patch? These two patches were already sent by Heiko Stübner.

  [PATCH] backlight: use of_find_backlight_by_node stub when backlight class disabled
  [PATCH] backlight: extend of_find_backlight_by_node stub-check to modules

Then, the one single patch will do as follows.

-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && (defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || \
+			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))

In this case, I cannot find any build errors.
Thank you.

Best regards,
Jingoo Han

> 
> ... error.
> 
> Bear in mind that defined(CONFIG_BACKLIGHT_CLASS_DEVICE) is false if
> it's built in as a module.  Change to nested #ifdefs instead.
> 
> > > diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> > > index adb14a8..d9cb644 100644
> > > --- a/include/linux/backlight.h
> > > +++ b/include/linux/backlight.h
> > > @@ -157,7 +157,7 @@ struct generic_bl_info {
> > >  	void (*kick_battery)(void);
> > >  };
> > >
> > > -#ifdef CONFIG_OF
> > > +#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
> > >  struct backlight_device *of_find_backlight_by_node(struct device_node *node);
> > >  #else
> > >  static inline struct backlight_device *
> >
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

