Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3LPLeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:34:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48878 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3LPLeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:34:12 -0500
X-AuditID: cbfee68e-b7fb46d00000186a-90-52aee5335133
From: Jingoo Han <jg1.han@samsung.com>
To: "'Eric Miao'" <eric.y.miao@gmail.com>
Cc: "'Rashika Kheria'" <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Josh Triplett'" <josh@joshtriplett.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131216112110.GA4849@rashika>
In-reply-to: <20131216112110.GA4849@rashika>
Subject: Re: [PATCH] drivers: video: Remove unused function
 genericbl_limit_intensity() in generic_bl.c
Date: Mon, 16 Dec 2013 20:34:10 +0900
Message-id: <001201cefa52$bd3dcf90$37b96eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac76UQVjXCwZhVTiTFiyWQQxPWmR9gAAULgg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI13jp+uCDGae5bfY0XaczeLywkus
	Fv8X5Fuc6PvAanF51xw2i3UPXzBZLFr8m91i/fxbbA4cHjtn3WX3eHXhDovHrde2Hn1bVjF6
	HL+xncnj8ya5ALYoLpuU1JzMstQifbsEroxZt9exF2zgr1jRvp2tgfEfTxcjJ4eEgIlE38Re
	ZghbTOLCvfVsXYxcHEICyxgl5n1fxg5TdGXGD1aIxHRGiVPXpkI5vxglbvy9ygZSxSagJvHl
	y2GwDhEBdYmb2yawgxQxCyxmkmi7e58FJCEkoC3x5F0/K4jNKaAjMX3VMrDdwgKZEq3dX8Bs
	FgFViVetV8BqeAVsJa5sOswIYQtK/Jh8D2gOB9BQdYkpU3JBwsxgIy+wgoQlgMKP/upCnGAk
	8W72fhaIEhGJfS/eMYKcIyHwlV3i8ZptLBCrBCS+TT7EAtErK7HpADQkJCUOrrjBMoFRYhaS
	xbMQFs9CsngWkg0LGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoREc98OxpsHrA8xJgNt
	n8gsJZqcD0wGeSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBcW6Qk5TNWsfX/XbXvni0VeyfZnH1qeMj4U9xYWla8znTfacudtk5UczAzzH39QGz
	Ri8Wi5AfW7LWyZfu//Wz1mZJe3v4+rmix0TtusWPik8LOrfDxmXz1PrjO89y5Pw1MIjNWtzI
	ffvdVeHNK8zXm1xSLuriUlwV/VDhCdcui+VRS7Tt844HKrEUZyQaajEXFScCAHdm+Kz8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQV3jp+uCDK5e4bLY0XaczeLywkus
	Fv8X5Fuc6PvAanF51xw2i3UPXzBZLFr8m91i/fxbbA4cHjtn3WX3eHXhDovHrde2Hn1bVjF6
	HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
	F58AXbfMHKB7lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZs26vYy/Y
	wF+xon07WwPjP54uRk4OCQETiSszfrBC2GISF+6tZ+ti5OIQEpjOKHHq2lRWCOcXo8SNv1fZ
	QKrYBNQkvnw5zA5iiwioS9zcNoEdpIhZYDGTRNvd+ywgCSEBbYkn7/rBxnIK6EhMX7WMGcQW
	FsiUaO3+AmazCKhKvGq9AlbDK2ArcWXTYUYIW1Dix+R7QHM4gIaqS0yZkgsSZgYbeYEVJCwB
	FH70VxfiBCOJd7P3s0CUiEjse/GOcQKj0Cwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgSnimfSOxhXNVgcYhTgYFTi4VWwXBckxJpYVlyZe4hRgoNZSYS3/jhQ
	iDclsbIqtSg/vqg0J7X4EGMy0JsTmaVEk/OBaSyvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhg9S592mRzksz/Xz6g+6dUZI+41brGvmIofaMsbeQo/Nu/q
	U8vmOFYUc3j+hRd7yz06S9gnPeGzL0l0/nkjYPrSrtVJYlV9djovG3Y8bxU7EX6+dLNt4Z+/
	ZlLtzlOyctc/yL53RyPC2+em+4miSrtMj8ZvwZl8fy22Svgfu183I/+Zh3JDhxJLcUaioRZz
	UXEiADJ7zTFZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 16, 2013 8:21 PM, Rashika Kheria wrote:
> 
> Removes unused function genericbl_limit_intensity() in
> backlight/generic_bl.c.
> 
> This eliminates the following warning in backlight/generic_bl.c:
> drivers/video/backlight/generic_bl.c:59:6: warning: no previous prototype for
> ‘genericbl_limit_intensity’ [-Wmissing-prototypes]

Hi Eric,

Originally, genericbl_limit_intensity() was added by you.
(commit: bfdcaa3 "lcd: add corgibl_limit_intensity() to corgi_lcd")

Currently, genericbl_limit_intensity() is not called anywhere
in mainline kernel. Can we remove this genericbl_limit_intensity()?


Best regards,
Jingoo Han

> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/video/backlight/generic_bl.c |   18 ------------------
>  1 file changed, 18 deletions(-)
> 
> diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
> index 5d8d652..67dfb93 100644
> --- a/drivers/video/backlight/generic_bl.c
> +++ b/drivers/video/backlight/generic_bl.c
> @@ -52,24 +52,6 @@ static int genericbl_get_intensity(struct backlight_device *bd)
>  	return genericbl_intensity;
>  }
> 
> -/*
> - * Called when the battery is low to limit the backlight intensity.
> - * If limit==0 clear any limit, otherwise limit the intensity
> - */
> -void genericbl_limit_intensity(int limit)
> -{
> -	struct backlight_device *bd = generic_backlight_device;
> -
> -	mutex_lock(&bd->ops_lock);
> -	if (limit)
> -		bd->props.state |= GENERICBL_BATTLOW;
> -	else
> -		bd->props.state &= ~GENERICBL_BATTLOW;
> -	backlight_update_status(generic_backlight_device);
> -	mutex_unlock(&bd->ops_lock);
> -}
> -EXPORT_SYMBOL(genericbl_limit_intensity);
> -
>  static const struct backlight_ops genericbl_ops = {
>  	.options = BL_CORE_SUSPENDRESUME,
>  	.get_brightness = genericbl_get_intensity,
> --
> 1.7.9.5

