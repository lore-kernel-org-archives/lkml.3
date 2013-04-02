Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761899Ab3DBJzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:55:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60512 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676Ab3DBJzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:55:10 -0400
X-AuditID: cbfee68d-b7f786d000005188-e8-515aaafd10a4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1364597502.1345.103.camel@x61.thuisdomein>
In-reply-to: <1364597502.1345.103.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: S3C64XX: remove obsolete Makefile line
Date: Tue, 02 Apr 2013 18:55:08 +0900
Message-id: <237a01ce2f88$28edbd90$7ac938b0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4sz/1PlMcrrmOqQzCwaluJGeI5EACt8IUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zQ92/q6ICDQ7/4LD4O+kYu8WkdQeY
	LDY9vsZqcXnXHDaLGef3MVncvsxrsejWGWYHdo+W5h42j9+/JjF6/F31gtlj85J6j43bnzB5
	fN4kF8AWxWWTkpqTWZZapG+XwJVx9tZetoJvHBX/r11kamBcyd7FyMEhIWAi8fupZBcjJ5Ap
	JnHh3nq2LkYuDiGBZYwSTavb2SASJhL7bm9mhkhMZ5Rom3WaCcL5yyix98tPZpAqNgENicPv
	n7GD2CICxRKb91wDK2IW6GGUaFl0EiwhJGAucaztDCuIzSlgIbGl8T9YXFjAQeLq42Ywm0VA
	VeLv3olgNq+ArcSfNR+ZIGxBiR+T77GAnM0soC4xZUouSJhZQFviybsLrBDfqEs8+qsLcYKR
	xNfpL9kgSkQk9r14xwhyjoTAV3aJuVN7oFYJSHybfIgFoldWYtMBZoiHJSUOrrjBMoFRYhaS
	xbMQFs9CsngWkg0LGFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoREcO8OxtsHrA8xJgNt
	n8gsJZqcD0wAeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9i
	ZOLglGpgZOE6kHh9u4HbNtO67EN99jaNDjNslZZlXBW+fm9K5ronbjKblm7fXHzv+QzzlLSU
	aAHzvNypkp5M0reDXNeJtE0pVbrpx/XoqYliTVf77MVtsW9O/LjsOUXJf2F/2NfyhieT1LcJ
	sNc3hm6J+/xx9YyCD1+On9r+5oyuy8f4W+GtvP/sN1nvU2Ipzkg01GIuKk4EAHl756v2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd2/q6ICDR4fZrH4O+kYu8WkdQeY
	LDY9vsZqcXnXHDaLGef3MVncvsxrsejWGWYHdo+W5h42j9+/JjF6/F31gtlj85J6j43bnzB5
	fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0ipJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+ytvWwF3zgq/l+7
	yNTAuJK9i5GTQ0LARGLf7c3MELaYxIV769m6GLk4hASmM0q0zTrNBOH8ZZTY++UnWBWbgIbE
	4ffPwLpFBIolNu+5BlbELNDDKNGy6CRYQkjAXOJY2xlWEJtTwEJiS+N/sLiwgIPE1cfNYDaL
	gKrE370TwWxeAVuJP2s+MkHYghI/Jt9j6WLkABqqLjFlSi5ImFlAW+LJuwusIGEJoPCjv7oQ
	JxhJfJ3+kg2iRERi34t3jBMYhWYhGTQLYdAsJINmIelYwMiyilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4QTyT3sG4qsHiEKMAB6MSD6/DnMhAIdbEsuLK3EOMEhzMSiK8W3WjAoV4UxIr
	q1KL8uOLSnNSiw8xJgO9OZFZSjQ5H5i88kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBkeUan3/nNle55VzhVavnuvX+MA9Q/fOxcXn4PKZasdmHH1lYbbyf
	P43/2KL7lyctNtLdbvuo4RtfMafIV3XlO58DPvpuNNYs1XnArWGc/17Yii2f/cRfzu/7A05J
	7J8vsHfh/MbgLVemXmt9UNC2b9VHu+Xmq2flnLp4gfMKqybL3uVPY76rFCuxFGckGmoxFxUn
	AgABP1cRVAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Commit a07613a54d700a974f3a4a657da78ef5d097315d ("Merge branch
> 'samsung/dt' into samsung/cleanup") added this line to
> arch/arm/mach-s3c64xx/Makefile:
>     obj-$(CONFIG_S3C64XX_DEV_SPI)	+= dev-spi.o
> 
> But at that time CONFIG_S3C64XX_DEV_SPI wasn't a valid Kconfig macro
> anymore and arch/arm/mach-s3c64xx/dev-spi.c was already removed. So we
> can remove this line.
> 
Yes, the dev-spi.c has been removed with Consolidation work of SPI platform devices.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  arch/arm/mach-s3c64xx/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s3c64xx/Makefile b/arch/arm/mach-
> s3c64xx/Makefile
> index f9ce1dc..31d0c91 100644
> --- a/arch/arm/mach-s3c64xx/Makefile
> +++ b/arch/arm/mach-s3c64xx/Makefile
> @@ -32,7 +32,6 @@ obj-$(CONFIG_S3C64XX_DMA)	+= dma.o
> 
>  obj-y				+= dev-uart.o
>  obj-y				+= dev-audio.o
> -obj-$(CONFIG_S3C64XX_DEV_SPI)	+= dev-spi.o
> 
>  # Device setup
> 
> --
> 1.7.11.7
> 
Looks OK to me, applied.

Thanks.

- Kukjin

