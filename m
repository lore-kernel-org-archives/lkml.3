Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3JWBVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:21:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40952 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3JWBVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:21:12 -0400
X-AuditID: cbfee691-b7f866d000001b8c-4c-5267247b48a3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-2-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-2-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 1/9] backlight: atmel-pwm-bl: fix reported brightness
Date: Wed, 23 Oct 2013 10:20:59 +0900
Message-id: <001901cecf8e$21764db0$6462e910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/RjWC/OkS1dQmy5wBjBYeX3+QAQgPPg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zA91qlfQgg1vfVSxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yWizY+IjRgcNjwa+tLB47Z91l99gz/werR9+WVYwe
	nzfJBbBGcdmkpOZklqUW6dslcGUcuPaNvWCfQEXDtY2sDYxvebsYOTkkBEwkOjZ+ZoGwxSQu
	3FvP1sXIxSEksIxRYvWjCWwwRZf/n2KGSCxilGhf8ZoFwvnFKPFhzQKwKjYBNYkvXw6zg9gi
	QPaT3iPsIEXMAhcYJY6/fMIIkhASqJS413uBCcTmFHCS+D79EVizsICnxLr+s2B3sAioSlz5
	MQdoHQcHr4CtxKztLiBhXgFBiR+T74GVMAtoSazfeZwJwpaX2LzmLVi5hIC6xKO/uiCmiICR
	xK9v9hAVIhL7XrxjBLlGQuAru0Rb/zVWiE0CEt8mH2KBaJWV2HSAGeJfSYmDK26wTGCUmIVk
	8Swki2chWTwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUJieOIOxvsHrA8xJgOt
	n8gsJZqcD0wBeSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAaGjQ+7Ll1+ugTbnOG0pZOxYyz65r2blBW+JXdeqCTVM3irO8Tbh/hMk388+uO3fe
	17/vUOb7kftFLj/OX3tvhehzu45tMU+eCS+R6Jzxy0CMq3VixLot3mvCjfNiKp3/TjdRXOX9
	UKv+a7zql8CvF6wa5iyNPHeTTTTc4qXAk03xK3Wd6i4+UWIpzkg01GIuKk4EAEdDOTb3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd1qlfQgg6ePFSxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yWizY+IjRgcNjwa+tLB47Z91l99gz/werR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOHDtG3vBPoGKhmsb
	WRsY3/J2MXJySAiYSFz+f4oZwhaTuHBvPVsXIxeHkMAiRon2Fa9ZIJxfjBIf1ixgA6liE1CT
	+PLlMDuILQJkP+k9wg5SxCxwgVHi+MsnjCAJIYFKiXu9F5hAbE4BJ4nv0x+BNQsLeEqs6z/L
	AmKzCKhKXPkxB2g1BwevgK3ErO0uIGFeAUGJH5PvgZUwC2hJrN95nAnClpfYvOYtWLmEgLrE
	o7+6IKaIgJHEr2/2EBUiEvtevGOcwCg0C8mgWUgGzUIyaBaSlgWMLKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxghPEM6kdjCsbLA4xCnAwKvHwWrSnBQmxJpYVV+YeYpTgYFYS4W32BQrx
	piRWVqUW5ccXleakFh9iTAZ6cyKzlGhyPjB55ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QDo8zDI2aHCjk21l3/e7hsg5q+yd+D7530LqdkG9pOVGzPVe68
	FZ8z28y+QGDihzsySerfmfIlfOsvf9hgdIbrgqS8bjbv/TN+8lEHvS/b+CwqufXM0emCTEuC
	rkTxI/F7U53Whiot+LrzwKzFrvOSE+qtc26XKrjr36yN/37WwlleIPp1HleWEktxRqKhFnNR
	cSIAsAji6FQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> The driver supports 16-bit brightness values, but the value returned
> from get_brightness was truncated to eight bits.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> index 66885fb..8aac273 100644
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
>  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
>  {
>  	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> -	u8 intensity;
> +	u32 intensity;
> 
>  	if (pwmbl->pdata->pwm_active_low) {
>  		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> @@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
>  			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
>  	}
> 
> -	return intensity;
> +	return (u16)intensity;

However, atmel_pwm_bl_get_intensity() should return 'int',
instead of 'u16'. Also, pwm_channel_readl() returns 'u32'.

Then, how about the following?

--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -70,17 +70,17 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 {
	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
-	u8 intensity;
+	u16 intensity;

	if (pwmbl->pdata->pwm_active_low) {
-		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
+		intensity = (u16) pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
			pwmbl->pdata->pwm_duty_min;
	} else {
-		intensity = pwmbl->pdata->pwm_duty_max -
+		intensity = (u16) pwmbl->pdata->pwm_duty_max -
			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
	}

-	return intensity;
+	return (int)intensity;
 }

Best regards,
Jingoo Han

