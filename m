Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaDYJDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:03:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35713 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaDYJC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:02:58 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-d3-535a24c18349
From: Jingoo Han <jg1.han@samsung.com>
To: "'Peter Griffin'" <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Milo Kim'" <milo.kim@ti.com>, "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-13-git-send-email-peter.griffin@linaro.org>
In-reply-to: <1398342509-10243-13-git-send-email-peter.griffin@linaro.org>
Subject: Re: [PATCH 12/13] video/backlight: LP855X needs PWM
Date: Fri, 25 Apr 2014 18:02:57 +0900
Message-id: <000901cf6065$269d7350$73d859f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9funbgOWIuRUDUSJ643F9FbhfzlwAqpAsg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zvu5Blahgg6cbFS3+TjrGbnF050Qm
	i8sLL7Fa3P96lNHi/aFnzBYn+j6wWlzeNYfNYvmvdSwWG2b8Y7FY9/AFk8X6+bfYHLg9fv+a
	xOixc9Zddo9XF+6weNy5tofN4/a/x8wefVtWMXocv7GdyePzJrkAjigum5TUnMyy1CJ9uwSu
	jMeH8woWcld8uHuNsYFxEWcXIyeHhICJxK7JP1ghbDGJC/fWs3UxcnEICSxjlFh+fCZTFyMH
	WNHrGf4Q8emMEp29C9ghnN+MEs2rH4N1swmoSXz5cpgdxBYR8JG4PXE6mM0scJ1JYt2NWoiG
	DkaJjf/7WECmcgp4STyY4wBiCgvYSPx8HAtSziKgKtEx/zxYK6+ArcSvHdMZIWxBiR+T77FA
	jNSSWL/zOBOELS+xec1bZog71SUe/dWFuMBIYuGMc1AXiEjse/GOEeQCCYG5HBKT711nhNgl
	IPFt8iEWiF5ZiU0HmCHhIClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGR
	XnFibnFpXrpecn7uJkZI/PftYLx5wPoQYzLQ+onMUqLJ+cD0kVcSb2hsZmRhamJqbGRuaUaa
	sJI476KHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGB3eXezUaDG731fZz2PNujtzmWft
	9btfLrrbZ3IeCrZs2sS92OqZRechf+sImwP9uW/OtP/8xfd+t6blv/0rLsyd1D//197rOzi/
	hj7ZI7Q/TGLtlpcSXZOvTyviTApbqukqkVBx0PSmaU/Xq6mi6mYzg8L4Lm37dyhd9axu0e6r
	s9TNBVmd+JVYijMSDbWYi4oTAbMLsKAVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQd2DKlHBBt1HZCz+TjrGbnF050Qm
	i8sLL7Fa3P96lNHi/aFnzBYn+j6wWlzeNYfNYvmvdSwWG2b8Y7FY9/AFk8X6+bfYHLg9fv+a
	xOixc9Zddo9XF+6weNy5tofN4/a/x8wefVtWMXocv7GdyePzJrkAjqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoFOVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBmPD+cVLOSu+HD3GmMD4yLOLkYODgkBE4nXM/y7GDmB
	TDGJC/fWs3UxcnEICUxnlOjsXcAO4fxmlGhe/ZgVpIpNQE3iy5fD7CC2iICPxO2J08FsZoHr
	TBLrbtRCNHQwSmz838cCsoFTwEviwRwHEFNYwEbi5+NYkHIWAVWJjvnnwVp5BWwlfu2Yzghh
	C0r8mHyPBWKklsT6nceZIGx5ic1r3jJD3Kwu8eivLsQFRhILZ5yDukBEYt+Ld4wTGIVmIZk0
	C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcHJ5Jr2DcVWDxSFGAQ5G
	JR7eCbKRwUKsiWXFlbmHGCU4mJVEeGdIRAUL8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w
	8eWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+P0Km0BDzH9
	TbO3KCfvb7eLCHrx4kvW6at+nO9DY44v2qsVnfiCqzU2/uCxo8tfH06crsi94cHEamYH8VvC
	EzeHnpjD3MwVendv4bbZIb77sxY469S96lh/hEMp3NYmyS3z2OxZbRV/zoh3T5/K0J5zUl5L
	Ndzw/OkDn0xWZu+WiJ5/++OGmjglluKMREMt5qLiRAAtSBRscgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 9:28 PM, Peter Griffin wrote:
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The LP855X driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> Cc: Milo Kim <milo.kim@ti.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 5675511..5d44905 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -386,7 +386,7 @@ config BACKLIGHT_LM3639
> 
>  config BACKLIGHT_LP855X
>  	tristate "Backlight driver for TI LP855X"
> -	depends on BACKLIGHT_CLASS_DEVICE && I2C
> +	depends on BACKLIGHT_CLASS_DEVICE && I2C && PWM
>  	help
>  	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8555, LP8556 and
>  	  LP8557 backlight driver.
> --
> 1.7.9.5

