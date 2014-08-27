Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaH0AiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:38:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34151 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbaH0AiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:38:00 -0400
X-AuditID: cbfee690-f79ce6d00000115a-43-53fd28662cb5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00bb01cfc12d$fb662c20$f2328460$%han@samsung.com>
 <20140826162817.GD26707@lee--X1>
In-reply-to: <20140826162817.GD26707@lee--X1>
Subject: Re: [PATCH 17/18] backlight: jornada720: remove 'else' after a return
Date: Wed, 27 Aug 2014 09:37:58 +0900
Message-id: <004201cfc18f$269c5f20$73d51d60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BSsJibDWf1SViTJuns+sb1LGLSgARDzcg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI900jb/BBr0zDS2O7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyumfvZ
	Cxq4K942b2JqYHzA0cXIySEhYCKxs3MdI4QtJnHh3nq2LkYuDiGBZYwSp9a/ZoQpenyvmxki
	sYhR4v+CH4wQzm9GiQl/25lAqtgE1CS+fDnMDmKLANk398wCizMLpEus2nuHBaJhCqNE388Z
	rCAJTgFdiZ4lm8FWCAv4SRxetIUZxGYRUJWYuekfWJxXwFbi1rMOdghbUOLH5HssEEPVJSbN
	W8QMYWtLPHl3AWgmB9Cp6hKP/uqCmCICRhJNc40gKkQk9r14B3azhMApdom5F/6wQqwSkPg2
	+RALRKusxKYDzBAPS0ocXHGDZQKjxCwki2chWTwLyeJZSFYsYGRZxSiaWpBcUJyUXmSiV5yY
	W1yal66XnJ+7iRESlxN2MN47YH2IUYCDUYmH98OCP8FCrIllxZW5hxhNgS6ayCwlmpwPjP68
	knhDYzMjC1MTU2Mjc0szJXHe11I/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw1m6x3Go2
	1ebBVOV72WvuVf7b8EK3sPvha6mPLYs/a93dHK0mdUsq1tLE3aLVd+3pzgWbpwQmL9QriP9m
	nvR20iLx1BzDrznX9b/kbu00fmRXlx0kX+q+oZEj+2zEzajcC5MzzeY/fbDOnTtY755Vrwzn
	w49/z+/79eegt36EgPybbGYv5XkdSizFGYmGWsxFxYkAxYCMSMYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd00jb/BBkv36Voc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZXTP3sxc0cFe8bd7E1MD4gKOLkZNDQsBE4vG9bmYIW0ziwr31
	bF2MXBxCAosYJf4v+MEI4fxmlJjwt50JpIpNQE3iy5fD7CC2CJB9c88ssDizQLrEqr13WCAa
	pjBK9P2cwQqS4BTQlehZspkRxBYW8JM4vGgL2DoWAVWJmZv+gcV5BWwlbj3rYIewBSV+TL7H
	AjFUXWLSvEXMELa2xJN3F4BmcgCdqi7x6K8uiCkiYCTRNNcIokJEYt+Ld4wTGIVmIRk0C8mg
	WUgGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcNQ/k97BuKrB4hCjAAejEg/v
	hwV/goVYE8uKK3MPMUpwMCuJ8CYr/A0W4k1JrKxKLcqPLyrNSS0+xGgK9OdEZinR5HxgQsor
	iTc0NjEzsjQyszAyMTdXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cCo53n3q7HfJcOPfYUn
	Npx2mqPdcOnVd7U8H+5cnZ3JnVd4y+2ul35ckjLjw3OZrOcT2bh37dQvjEx4bWa3gH3mZiHJ
	aLZ0T8dfZR48+qf+/2iZ9FnXRzxPxdvE4/y7N0FZiafrYs1DQ+QU3sxhSV14+fS9JyXcbydf
	73L9bJRdyh1yR7hfe5USS3FGoqEWc1FxIgAxZOEsEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 1:28 AM, Lee Jones wrote:
> On Tue, 26 Aug 2014, Jingoo Han wrote:
> 
> > Fixed the following checkpatch warning.
> >
> >   WARNING: else is not generally useful after a break or return
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/video/backlight/jornada720_lcd.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> > index 228bc319de19..1cf3d59f1e7f 100644
> > --- a/drivers/video/backlight/jornada720_lcd.c
> > +++ b/drivers/video/backlight/jornada720_lcd.c
> > @@ -30,8 +30,8 @@ static int jornada_lcd_get_power(struct lcd_device *ld)
> >  	/* LDD2 in PPC = LCD POWER */
> >  	if (PPSR & PPC_LDD2)
> >  		return FB_BLANK_UNBLANK;	/* PW ON */
> > -	else
> > -		return FB_BLANK_POWERDOWN;	/* PW OFF */
> > +
> > +	return FB_BLANK_POWERDOWN;	/* PW OFF */
> 
> How about:
> 
>   return PPSR & PPC_LDD2 ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;

OK, it looks good.
Thank you for your suggestion!

Best regards,
Jingoo Han

> 
> >  }
> >
> >  static int jornada_lcd_get_contrast(struct lcd_device *ld)
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

