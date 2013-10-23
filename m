Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3JWJfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:35:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50301 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3JWJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:35:45 -0400
X-AuditID: cbfee691-b7f866d000001b8c-c2-526798701cab
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-2-git-send-email-jhovold@gmail.com>
 <001901cecf8e$21764db0$6462e910$%han@samsung.com>
 <20131023085128.GA11025@localhost>
In-reply-to: <20131023085128.GA11025@localhost>
Subject: Re: [PATCH 1/9] backlight: atmel-pwm-bl: fix reported brightness
Date: Wed, 23 Oct 2013 18:35:43 +0900
Message-id: <002401cecfd3$3ed5ef60$bc81ce20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PzRUgv6TljSHeTYa7/iB0wGc+cAABiF6g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY92CGelBBh1zuSxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yWizY+IjRgcNjwa+tLB47Z91l99gz/werR9+WVYwe
	nzfJBbBGcdmkpOZklqUW6dslcGWcuNrMUrBEuuLOkewGxo+iXYwcHBICJhIv5od3MXICmWIS
	F+6tZ+ti5OIQEljGKHG9fRM7TM3l2UwQ8UWMEi8fHWOBcH4xShx6vI8FpJtNQE3iy5fD7CC2
	CJD9pPcIO0gRs8AFRonjL58wQnRcYpQ48aaPEWQsp4C+xOuzdSANwgKeEuv6z7KAhFkEVCV+
	fNYDCfMK2ErsO/SWGcIWlPgx+R7YLmYBLYn1O48zQdjyEpvXgNSAHKou8eivLsQJRhJnnq9j
	hygRkdj34h3YBRICX9kleub9YANJsAgISHybfIgFoldWYtMBZkhASEocXHGDZQKjxCwkm2ch
	2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRESvxN3MN4/YH2IMRlo/URm
	KdHkfGD855XEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QDo8apGSlXHG6tmJ1vOnlLUL2Uve+RzaVdZeayh5fOvvakybJWT7J9Gf8TXa38woqXz+aw
	XXgcdNBLift5Ptfh7GWxPs1Ze/4f5tFZsfVgDMOh2DNq6b+YDh96mm12yin3t6zkBHmNZyv9
	WM8U7D27W28/68z4zXHrdzROf3Xb9vnvl1FPEkS/8yqxFGckGmoxFxUnAgACc3oo9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd2CGelBBo+WsVq8PKRpcXnhJVaL
	vaukLU70fWC1uLxrDpvFt8vN7Ba7dz1ltViw8RGjA4fHgl9bWTx2zrrL7rFn/g9Wj74tqxg9
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYceJqM0vBEumKO0ey
	Gxg/inYxcnBICJhIXJ7N1MXICWSKSVy4t56ti5GLQ0hgEaPEy0fHWCCcX4wShx7vYwGpYhNQ
	k/jy5TA7iC0CZD/pPcIOUsQscIFR4vjLJ4wQHZcYJU686WMEWcEpoC/x+mwdSIOwgKfEuv6z
	LCBhFgFViR+f9UDCvAK2EvsOvWWGsAUlfky+B7aLWUBLYv3O40wQtrzE5jUgNSBHq0s8+qsL
	cYKRxJnn69ghSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIEp4dn0jsYVzVYHGIU4GBU4uG1bE8LEmJNLCuuzD3EKMHBrCTCqz4hPUiINyWx
	siq1KD++qDQntfgQYzLQnxOZpUST84GpK68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGBc68K/T2/PIVTjF4vFGYdu/WZPsE26rX7jpedf853rPO9M78jbu
	kMr3OXPAzaV/av6hB76f3n63inr00ifBPXr7IYmdCSoxhwrrfH+90zWx41t9vvOl27rJX6uj
	XTL73b7XB+/vTaqbkHxii9jCJbG7HS4GTP92fuuqH7oT2WbsKHz7Ll1SbY4SS3FGoqEWc1Fx
	IgDRD/aYUwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 5:51 PM, Johan Hovold wrote:
> On Wed, Oct 23, 2013 at 10:20:59AM +0900, Jingoo Han wrote:
> > On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> > >
> > > The driver supports 16-bit brightness values, but the value returned
> > > from get_brightness was truncated to eight bits.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > > ---
> > >  drivers/video/backlight/atmel-pwm-bl.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> > > index 66885fb..8aac273 100644
> > > --- a/drivers/video/backlight/atmel-pwm-bl.c
> > > +++ b/drivers/video/backlight/atmel-pwm-bl.c
> > > @@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
> > >  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> > >  {
> > >  	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> > > -	u8 intensity;
> > > +	u32 intensity;
> > >
> > >  	if (pwmbl->pdata->pwm_active_low) {
> > >  		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> > > @@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> > >  			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> > >  	}
> > >
> > > -	return intensity;
> > > +	return (u16)intensity;
> >
> > However, atmel_pwm_bl_get_intensity() should return 'int',
> > instead of 'u16'.
> 
> Yes, but the cast to int is implicit. Perhaps
> 
> 	return (intensity & 0xffff);
> 
> (or just a comment) would make it more clear why the cast is there.
> 
> > Also, pwm_channel_readl() returns 'u32'.
> 
> Yes, (and only the 16 least-significant bits are used). That and the
> fact that the platform-data limits are currently unsigned long (I was
> considering fixing this later) was why I preferred keeping all register
> value manipulation in u32 and do a single cast at the end.
> 
> > Then, how about the following?
> >
> > --- a/drivers/video/backlight/atmel-pwm-bl.c
> > +++ b/drivers/video/backlight/atmel-pwm-bl.c
> > @@ -70,17 +70,17 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
> >  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> >  {
> > 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> > -	u8 intensity;
> > +	u16 intensity;
> >
> > 	if (pwmbl->pdata->pwm_active_low) {
> > -		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> > +		intensity = (u16) pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> > 			pwmbl->pdata->pwm_duty_min;
> 
> This would actually introduce a new conversion warning (unless you add
> parentheses as well) as pwm_duty_min is unsigned long. Same below.
> 
> > 	} else {
> > -		intensity = pwmbl->pdata->pwm_duty_max -
> > +		intensity = (u16) pwmbl->pdata->pwm_duty_max -
> > 			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> > 	}
> >
> > -	return intensity;
> > +	return (int)intensity;
> >  }
> 
> However, if you feel strongly about this, I'll respin the series (a later
> patch would likely no longer apply), use u16 and add casts to the two
> assignments.

Thank you for your kind and detailed description. :-)
OK, I have no objection on your original patch.

Would you re-send these patches with my Acked-by with CC'ing  Andrew Morton,
Tomi Valkeinen? Then, these patches can be merged through mm-tree.

Best regards,
Jingoo Han 

