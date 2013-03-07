Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3CGBCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:02:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40783 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3CGBCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:02:09 -0500
X-AuditID: cbfee690-b7f6b6d000004563-2a-5137e70f1553
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1362566365.16460.173.camel@x61.thuisdomein>
In-reply-to: <1362566365.16460.173.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: EXYNOS: change HAVE_SAMSUNG_KEYPAD to KEYBOARD_SAMSUNG
Date: Thu, 07 Mar 2013 10:02:07 +0900
Message-id: <014b01ce1acf$63ada580$2b08f080$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aVuC4j7nuSiBrQGGW48GMto9dggAd6HnQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zfV3+5+aBBg8Wq1hc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVc+36DuWADd8Xq/6/ZGhhXcnYxcnJICJhIPHt/nA3C
	FpO4cG89kM3FISSwjFFiyq0LbDBFUybOYYVILGKUuHChmxHC+cso8br1NSNIFZuAhsTh98/Y
	QWwRAT+Jg13nmUCKmAVOMkqc7/gLViQkYCEx++tKZhCbU8BSomFSE1Ccg0NYIEBi5qpKkDCL
	gKrE9Oc7wEp4BWwl3rxbygJhC0r8mHyPBaScWUBdYsqUXJAws4C2xJN3F1hBwhJA4Ud/dSEu
	MJKYdHozE0SJiMS+F+/ATpYQWMcucfToTTaIVQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSY
	hWTxLITFs5AsnoVkwwJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIRE2YQfjvQPWhxiT
	gbZPZJYSTc4HRmheSbyhsbGJmYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTDylxkff5+gya7vcOjA2sVb1XbrcYUpr3d37l7b3X9swqSgxeX+z6ZWh9zJ2Lnt
	5b5LguUmCwpTnF+ZmD2aek+24NXvvMtfHzP42s08cWbydFk2xiUxne0853TfipwxnZbS7bz+
	S4maRUYqk4oC88S8Kf28Vxl1jd+GO867MCH5q+KpJv+q061KLMUZiYZazEXFiQBwzYgWxgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAV3+5+aBBre3KVhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXPt+g7lgA3fF
	6v+v2RoYV3J2MXJySAiYSEyZOIcVwhaTuHBvPVsXIxeHkMAiRokLF7oZIZy/jBKvW18zglSx
	CWhIHH7/jB3EFhHwkzjYdZ4JpIhZ4CSjxPmOv2BFQgIWErO/rmQGsTkFLCUaJjUBxTk4hAUC
	JGauqgQJswioSkx/vgOshFfAVuLNu6UsELagxI/J91hAypkF1CWmTMkFCTMLaEs8eXeBFSQs
	ARR+9FcX4gIjiUmnNzNBlIhI7HvxjnECo9AsJINmIQyahWTQLCQdCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEx+8zqR2MKxssDjEKcDAq8fBy5JsHCrEmlhVX5h5ilOBgVhLhvbsE
	KMSbklhZlVqUH19UmpNafIgxGejNicxSosn5wNSSVxJvaGxiZmRpZGZhZGJuTpqwkjgv46kn
	AUIC6YklqdmpqQWpRTBbmDg4pRoYC46KJjZe6vG4rWQVl3lhMufbVaw8t/2CXU59tMpvMsq9
	qbrk560K+eUNKs+3zN+WoHZz3+byf9snberM54x2y/P7szn74OxA+ccCzzjiDaz5Pq9UF7wn
	2WoWbehccP/Iut/GWvN752ZVaWxxnlh2T2dOwPuAN6tLT1ouTtZ+m//gGEfL/bcLlViKMxIN
	tZiLihMBuOMpciMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Commit 6b5ab4f442e32f248b6fad29aafd1d5153f4dbd3 ("ARM: EXYNOS: Add
> Exynos4 device tree enabled board file") added
> 	select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD
> 
> to the MACH_EXYNOS4_DT Kconfig entry. But there's no Kconfig symbol
> HAVE_SAMSUNG_KEYPAD. Since this select statement depends on
> INPUT_KEYBOARD this entry should select KEYBOARD_SAMSUNG instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with "git grep" only.
> 
> 1) Perhaps the fact that the symbol KEYBOARD_SAMSUNG enables a driver
> called samsung-keypad caused confusion here. Anyhow, my choice for
> KEYBOARD_SAMSUNG is only educated guesswork.
> 
>  arch/arm/mach-exynos/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index 6c2bdc3..068aeb5 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -403,7 +403,7 @@ config MACH_EXYNOS4_DT
>  	depends on ARCH_EXYNOS4
>  	select ARM_AMBA
>  	select CPU_EXYNOS4210
> -	select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD
> +	select KEYBOARD_SAMSUNG if INPUT_KEYBOARD
>  	select PINCTRL
>  	select PINCTRL_EXYNOS
>  	select USE_OF
> --
> 1.7.11.7

Looks good to me, applied.

BTW, just to use only 8~12 digits of commit ID, "Commit 6b5ab4f4" is enough instead of full commit ID.

Thanks.

- Kukjin

