Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaFEB57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:57:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25784 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaFEB54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:57:56 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-f3-538fce962d2f
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        wsa@the-dreams.de, khali@linux-fr.org, linus.walleij@linaro.org,
        paul.gortmaker@windriver.com,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Jim Davis'" <jim.epost@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CA+r1Zhi9Qd4aZ2WJ02K4Gv=zg7QvG+r=t2VpiXRKXcYRc1vt=A@mail.gmail.com>
 <1401900992-16581-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1401900992-16581-1-git-send-email-laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] i2c: pca954x: Fix compilation without CONFIG_GPIOLIB
Date: Thu, 05 Jun 2014 10:57:41 +0900
Message-id: <007001cf8061$89337e30$9b9a7a90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+AFeMc05LSWXQMR4i+/Bv06nwL+wAS4FMw
Content-language: ko
x-cr-hashedpuzzle: JPZ6 VXeN Xx1G dyFp uAkf ABpqlA== AEK2gQ== AHwsCg== AILdyw==
 AIQ6HQ== AJKbOA== AJR8Kg== ALBp1w== AMUNZg== AN/VJA==
 AO6NDA==;11;agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGoAaQBtAC4AZQBwAG8AcwB0AEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBrAGgAYQBsAGkAQABsAGkAbgB1AHgALQBmAHIALgBvAHIAZwA7AGwAYQB1AHIAZQBuAHQALgBwAGkAbgBjAGgAYQByAHQAQABpAGQAZQBhAHMAbwBuAGIAbwBhAHIAZAAuAGMAbwBtADsAbABpAG4AdQBzAC4AdwBhAGwAbABlAGkAagBAAGwAaQBuAGEAcgBvAC4AbwByAGcAOwBsAGkAbgB1AHgALQBpADIAYwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG4AZQB4AHQAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHAAYQB1AGwALgBnAG8AcgB0AG0AYQBrAGUAcgBAAHcAaQBuAGQAcgBpAHYAZQByAC4AYwBvAG0AOwBzAGYAcgBAAGMAYQBuAGIALgBhAHUAdQBnAC4AbwByAGcALgBhAHUAOwB3AHMAYQBAAHQAaABlAC0AZAByAGUAYQBtAHMALgBkAGUA;Sosha1_v1;7;{4B279C9F-859B-4962-B0AC-A1C803CD300C};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 05 Jun 2014 01:57:23 GMT;UgBlADoAIABbAFAAQQBUAEMASA
	BdACAAaQAyAGMAOgAgAHAAYwBhADkANQA0AHgAOgAgAEYAaQB4ACAAYwBvAG0AcABpAGwAYQB0AGkAbwBuACAAdwBpAHQAaABvAHUAdAAgAEMATwBOAEYASQBHAF8ARwBQAEkATwBMAEkAQgA=
x-cr-puzzleid: {4B279C9F-859B-4962-B0AC-A1C803CD300C}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t8zfd1p5/qDDZ6s4LS4vPASq0X/q+XM
	Fo1/Iy06Jy5ht5jyZzmTRcffL4wWl3fNYbM4uLCN0eLa3uPMFlv3XmW3WHliFrMDt0fjjRts
	Hjtn3WX3mN0xk9XjzrU9bB5XGk6yefRtWcXocfLUExaPz5vkPNZv2coUwBnFZZOSmpNZllqk
	b5fAlXHm7C/WgoUCFRuaTzI1MD7i7WLk5JAQMJFYuHkNC4QtJnHh3nq2LkYuDiGBZYwSb76f
	ZYYpmvj9GBOILSSwiFHi1YN4iKLfjBITp95gBEkIC/hJNM2ZBNbAJqAm8eXLYfYuRg4OEYFw
	iR8To0DCzAKTmSQ+X66G6J3FKPFj0XWwzZwCIRLPJtxkh5jjKbFxyzYwm0VAVeLssfVgNq+A
	rcSsO7ugbEGJH5PvsUAMVZeYNG8RM4StLfHk3QVWkL0SQPFHf3VBwiICRhLXXr9lhygRkdj3
	4h0jxF/TOCWeTNCBsE0lHt99xA5hn+GQmP+NE+IEAYlvkw+xQIyUldh0ABokkhIHV9xgmcAo
	PQvJQbOQHDQLyUGzkGxewMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkofTtYLx5wPoQ
	YzLQ+onMUqLJ+cCElFcSb2hsZmRhamJqbGRuaUaasJI476KHSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGEO9t559c9jtyQWZsx/rdb7o3X/Nt1SQj6/asEjNh6VlvYT31maBJ0deb2j3
	y9F4qs2st7vOm3XV7hkfjm0zCBH/pzWrzz3k//v3cZErhVmMPHMvarokfCjtnNMx6f4Jh8wt
	qxKij/ilrVnr+P6b7R/r27UL2Xy8ri6yFmN82jN5AYdl2MF//UosxRmJhlrMRcWJAOWo38o+	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xgO60c/3BBlMnsVhcXniJ1aL/1XJm
	i8a/kRadE5ewW0z5s5zJouPvF0aLy7vmsFkcXNjGaHFt73Fmi617r7JbrDwxi9mB26Pxxg02
	j52z7rJ7zO6Yyepx59oeNo8rDSfZPPq2rGL0OHnqCYvH501yHuu3bGUK4IxqYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpXSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx5uwv1oKFAhUbmk8yNTA+4u1i5OSQEDCRmPj9
	GBOELSZx4d56NhBbSGARo8SrB/FdjFxA9m9GiYlTbzCCJIQF/CSa5kxiBrHZBNQkvnw5zN7F
	yMEhIhAu8WNiFEiYWWAyk8Tny9UQvbMYJX4sus4CkuAUCJF4NuEmO8QcT4mNW7aB2SwCqhJn
	j60Hs3kFbCVm3dkFZQtK/Jh8jwViqLrEpHmLmCFsbYkn7y6wguyVAIo/+qsLEhYRMJK49vot
	O0SJiMS+F+8YIf6axinxZIIOhG0q8fjuI/YJjKKzkGyYhWTDLCQbZiEZtYCRZRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcMJ6Jr2DcVWDxSFGAQ5GJR7eCQH9wUKsiWXFlbmHGCU4mJVE
	eP8UA4V4UxIrq1KL8uOLSnNSiw8xJgMDYCKzlGhyPjCZ5pXEGxqbmBlZGplZGJmYm5MmrCTO
	e7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo6SzpFeC0Ic/U4psvti9qZRfPGneN6PJax7v2RT2
	5ZIjr8Wdz/m1arPfz2ExkrC/acTxrfx42vkfx7YJLpPMV3iYsXidXunHUNPOD7pKTjuPet1f
	fvat5j+7GW9ZpCL4FHdNdVF9e2mV1mTOUonFZ9Pf99zZ0MHxY625+W4eU7+3h54rb7R/zK3E
	UpyRaKjFXFScCABAD7N2nAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 05, 2014 1:57 AM, Laurent Pinchart write/l
> 
> The pca954x driver recently switched to the GPIO descriptor API without
> including the correct <linux/gpio/consumer.h> header. This breaks
> compilation without CONFIG_GPIOLIB.
> 
> drivers/i2c/muxes/i2c-mux-pca954x.c: In function ‘pca954x_probe’:
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:2: error: implicit declaration
> of function ‘devm_gpiod_get’ [-Werror=implicit-function-declaration]
>   gpio = devm_gpiod_get(&client->dev, "reset");
>   ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:204:7: warning: assignment makes
> pointer from integer without a cast [enabled by default]
>   gpio = devm_gpiod_get(&client->dev, "reset");
>        ^
> drivers/i2c/muxes/i2c-mux-pca954x.c:206:3: error: implicit declaration
> of function ‘gpiod_direction_output’
> [-Werror=implicit-function-declaration]
>    gpiod_direction_output(gpio, 0);
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/i2c/muxes/i2c-mux-pca954x.o] Error 1
> 
> Fix it by including the right header.
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/i2c/muxes/i2c-mux-pca954x.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
> index c2c443f..9bd4212 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> @@ -36,12 +36,11 @@
>   */
> 
>  #include <linux/device.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-mux.h>
>  #include <linux/i2c/pca954x.h>
>  #include <linux/module.h>
> -#include <linux/of_gpio.h>
>  #include <linux/slab.h>
> 
>  #define PCA954X_MAX_NCHANS 8
> --
> Regards,
> 
> Laurent Pinchart

