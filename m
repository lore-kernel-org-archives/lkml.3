Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaBJAWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:22:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52376 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBJAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:22:47 -0500
X-AuditID: cbfee690-b7f266d00000287c-0f-52f81bd5677e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Levente Kurusa'" <levex@linux.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'FBDEV list'" <linux-fbdev@vger.kernel.org>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1391762601-4560-1-git-send-email-levex@linux.com>
In-reply-to: <1391762601-4560-1-git-send-email-levex@linux.com>
Subject: Re: [PATCH] backlight: replace kfree with put_device
Date: Mon, 10 Feb 2014 09:22:44 +0900
Message-id: <003701cf25f6$3807c6d0$a8175470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j4QEYSC67ulp7SSGXSfnmHNsCJACFOYmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zI92r0j+CDK7t47eYs34Nm8XRnROZ
	LC4vvMRqcf/rUUaLpR1v2S1O9H1gtbi8aw6bxbqHL5gs1s+/xebA6bFz1l12j1cX7rB43Lm2
	h83jxIzfLB5Prkxn8ujbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGV07xUvmMBRsXD/
	MpYGxotsXYycHBICJhKHfrxmhLDFJC7cWw8U5+IQEljGKNE58wA7TNGijpXsEIlFjBLHGrYw
	gSSEBH4xSizvqAOx2QTUJL58OQxUxMEhIqAv0daiAVLPLHCBSWJ601ZGiHo7iQ0NG5lBbE4B
	e4md87pYQWxhAVuJvY96mEF6WQRUJZqvxoKEeYHCz3e+Z4OwBSV+TL7HAmIzC2hJrN95nAnC
	lpfYvOYtWKuEgLrEo7+6IGERASOJGVNXQZWLSOx78Y4R5BwJgV4OiY7z98B6WQQEJL5NPsQC
	0SsrsekAM8S7khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5noFSfmFpfm
	pesl5+duYoTE+oQdjPcOWB9iTAZaP5FZSjQ5H5gq8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuU
	FCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcXmc78RMpi1FVm4nagzt1SUe2+T/9utILVFU
	/yT6atqJVROWGEX9/Nl/XHfuC0HmRUzlQjUVl4vVWy7IxqwSiD9YUzQ1OyNIXjxSMO1KLbNq
	MutyrcjzTNPfs4gcnO3ddeyqTbc1h9jZ68zWV67dMtto+jjs0j/LLJ3e4K271dqsnL5tPVqj
	xFKckWioxVxUnAgAGKFczgsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd2r0j+CDB41cVvMWb+GzeLozolM
	FpcXXmK1uP/1KKPF0o637BYn+j6wWlzeNYfNYt3DF0wW6+ffYnPg9Ng56y67x6sLd1g87lzb
	w+ZxYsZvFo8nV6YzefRtWcXocfzGdiaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AOVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jFmdO8VL5jAUbFw/zKWBsaLbF2MnBwSAiYSizpWskPYYhIX7q0HinNxCAks
	YpQ41rCFCSQhJPCLUWJ5Rx2IzSagJvHly2GgBg4OEQF9ibYWDZB6ZoELTBLTm7YyQtTbSWxo
	2MgMYnMK2EvsnNfFCmILC9hK7H3UwwzSyyKgKtF8NRYkzAsUfr7zPRuELSjxY/I9FhCbWUBL
	Yv3O40wQtrzE5jVvwVolBNQlHv3VBQmLCBhJzJi6CqpcRGLfi3eMExiFZiGZNAvJpFlIJs1C
	0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAieSa9g3FVg8UhRgEORiUe3h1/vgcJ
	sSaWFVfmHmKU4GBWEuF9eRcoxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnAJJdXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyeO7i+/cv2N1JWcHB/XB6t
	VDTjZ0ZTr3tsfUu64q/82SfWqKYuPrqUcc751W7SM0KP/UqcLzHHLkrarOpbhFxMsNLHRbHL
	Au/5V8X4hxlv84z6oL79WoRqFgvL+8ajyqfz83x6LrjmPL1ns965e67kTMHv0hY6P3al9th1
	XTcw2VB2fXa1vRJLcUaioRZzUXEiADUvJkRoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 5:43 PM, Levente Kurusa wrote:
> 
> As per the comments on device_register, we shouldn't call kfree()
> right after a device_register() failure. Instead call put_device(),
> which in turn will call bl_device_release resulting in a kfree to the
> full structure.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

(+cc Bryan Wu, Lee Jones)

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/backlight.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 5d05555..20b276e 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -333,7 +333,7 @@ struct backlight_device *backlight_device_register(const char *name,
> 
>  	rc = device_register(&new_bd->dev);
>  	if (rc) {
> -		kfree(new_bd);
> +		put_device(&new_bd->dev);
>  		return ERR_PTR(rc);
>  	}
> 
> --
> 1.8.3.1

