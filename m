Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3I3HX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:23:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25152 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3I3HXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:23:55 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-ff-524926cc8488
From: Kukjin Kim <kgene@kernel.org>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Martin Schwidefsky'" <schwidefsky@de.ibm.com>
References: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
In-reply-to: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
Subject: RE: [PATCH 1/5] ARM: Kconfig: Move if ARCH_S3C64XX statement to
 mach-s3c64xx/Kconfig
Date: Mon, 30 Sep 2013 16:22:51 +0900
Message-id: <069301cebdad$df658f90$9e30aeb0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac68d6ek8FcEBKBWQD2/qzV3XPNZ+QBNgEew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRzGec85O86FeJqXXsVLGCoK07z2mrYuUJwgzOqDVKCudVLzyqYR
	RGhLTIeaToXYpJvmZZjaZqQzl87MSPGS4rUsryhoCZNh5iK30we/9u33/nne53n48+fi/DmO
	Kzc5PYuRpItSvUge0f9nOUQw4HP24uENmTsaGzFgyKz4YIMUTV0YqpxbJNGqwQ8tT3diyDRW
	gKGKnToMaRbGOUj7ZAegUV0ViYpaXnPQoyE9hmZG7dBIkyf6NGEkUaHuIQf1rD3goJH6TQwZ
	B/Nt0Kp2DUNq3Q444Uy3GGUknXe/iKR/bysA3T1vIGmzegWn25VfbWiNupCkv4y/JWlDTwGg
	tTU59NhHGYfWr9eSdEmrenfUf4c2ajxi7K/woq4zqcm3GEmgMIGXNFh5PFO27/bLzVoyF0xx
	5cCWC6lQqG34TrDsDIdnm0k54HH5VC2ADcOdmBxwrSJ5qxs7fw5gxbs6G/ZhBrCjdNgqIqlD
	8J4s0GLkQPnDZ60yq6kjdQ52PK4gLYxTqxxoehFhYT51GuaqpjEL21Jn4E/FAG6xcaDi4Rv9
	ZQsSlDcszocWhR0VBEs6i3GW98Ot8lmCdfSHze19GMueUNu4jrONfeG8WcAWCIbVi73/JI5Q
	v/IDWMpDqs4WflvasDYjKAqayg0E+9cdarpwdiMusLt+kigFLso9yco9yco9yco9EU8BoQZO
	TKY4U3otURIUIBWlSbPTEwPEGWkawJ5XcRuY6Yo0APFufBnu6iTO2D2/9Kz4oJDwYBQWGhYS
	fCQi/P/GXgfsfPIiL/CpRFEWk8IwmYwkXpKdykgNAOPauuYClw6wPGuYiKuOjb5qzptYEOpS
	axTTv7wFpq1FYX1NSVW2/ftco6Owm6fSrL0KyInyhfIRfCB+4OT2UlzYkMqfMYULhKQq8RJV
	g8zlB+t6BacmnWZjPcKjUz4H9ok5EUc3bqh0bgnBjW0xU2VFyx7b6Jig++Z5Py/H6s27KV6E
	NEkU5I9LpKK/Rr2NvXQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsVy+t9jAd0zap5BBivniVlcuXiIyeLvpGPs
	FpPWHWCymPrwCZvFy0OaFs9u7WWy+Halg8liyp/lTBabHl9jtdg8/w+jxeVdc9gsejZsZbWY
	cX4fk8Xty7wWF9fJW5y6/pnNonNXP6vF4TftrBYXV3xhsvh8ro3d4uXmN0wWq3b9YXQQ89jw
	uYnNo6W5h83j969JjB4HHx1i8/i76gWzx85Zd9k9Nq3qZPO4c20Pm8ehwx2MHpuX1HtcOdHE
	6rHv7TI2j74tq4BCp6s9Pm+SC+CPamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6X0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMeYcW6qfUETd8XaL8vYGhhvcnQxcnBICJhIdG2R6WLkBDLFJC7cW8/WxcjFISSwiFFiyv7l
	7BDOX0aJ3RMuMIE0sAkoSzQ26YM0CAtoSSzc0sQCYosI+EjsnjeFDcRmFnjJKvFtqSWILSTg
	KtEw+xYTiM0p4CbxftIZZpAxwgLxEtv3RYKYLAKqEr1tEiAVvAKGEn17e5khbEGJH5PvsUBM
	1JJYv/M4E4QtL7F5zVtmiOvVJR791YU4wEhi8ZOjUCUiEvtevGOcwCg8C8mkWUgmzUIyaRaS
	lgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxglPjM+kdjKsaLA4xCnAwKvHwWiz1CBJi
	TSwrrsw9xCjBwawkwvuVzzNIiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBaTuvJN7Q2MTM
	yNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjZLb0++p09ZfX0rJencMl2
	ifS8yJsfrb5nVh6r/mZTkPZ1itbhr4t9MiONp4gtP+btoVb/8MTxuGvT9H4L2hk7HfLPOv00
	raH15C6nO0GvbwXMNBYRnb6oU3ee67ewsGcl7eKigcxLb/N9z/xVKzE/1WzChqV1zR0TGne9
	ufry3OaSrZz+mUFKLMUZiYZazEXFiQBbpEPY0QMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> All other platforms have this condition checked inside their own Kconfig
> files, so for consistency this patch makes it this way for mach-s3c64xx
> as well.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  arch/arm/Kconfig              | 2 --
>  arch/arm/mach-s3c64xx/Kconfig | 4 ++++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index b766dad..dc51f8a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -995,9 +995,7 @@ source "arch/arm/mach-sti/Kconfig"
> 
>  source "arch/arm/mach-s3c24xx/Kconfig"
> 
> -if ARCH_S3C64XX
>  source "arch/arm/mach-s3c64xx/Kconfig"
> -endif
> 
>  source "arch/arm/mach-s5p64x0/Kconfig"
> 
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index bd14e3a..0e23910 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -3,6 +3,8 @@
>  #
>  # Licensed under GPLv2
> 
> +if ARCH_S3C64XX
> +
>  # temporary until we can eliminate all drivers using it.
>  config PLAT_S3C64XX
>  	bool
> @@ -322,3 +324,5 @@ config MACH_S3C64XX_DT
>  	  board.
>  	  Note: This is under development and not all peripherals can be
>  	  supported with this machine file.
> +
> +endif
> --
> 1.8.3.2

Looks good to me, applied 1 to 5 patches into cleanup.

Thanks,
Kukjin

