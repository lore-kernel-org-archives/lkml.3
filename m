Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaGJGwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:52:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58944 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaGJGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:51:58 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-7d-53be380a6369
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kishon@ti.com, dianders@chromium.org,
        gautam.vivek@samsung.com, spk.linux@gmail.com, tomasz.figa@gmail.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404906569-28026-1-git-send-email-sachin.kamat@samsung.com>
 <1404906569-28026-2-git-send-email-sachin.kamat@samsung.com>
In-reply-to: <1404906569-28026-2-git-send-email-sachin.kamat@samsung.com>
Subject: Re: [PATCH v2 2/2] phy: Kconfig: Update config for Exynos USB DRD
Date: Thu, 10 Jul 2014 15:51:54 +0900
Message-id: <003a01cf9c0b$6f8eda40$4eac8ec0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+bbGiOhEN90elWQiuwp9ajhJSA7QAnu21g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zfV0ui33BBvtuWFicXXaQzaLtykF2
	i8sLL7FaXHjaw2ZxedccNosZ5/cxWVy5dIrNouXrORaLVbv+MDpwesxuuMjisXPWXXaPvi2r
	GD2O39jO5PF5k1wAaxSXTUpqTmZZapG+XQJXxtpp9xkLLnNUfHzVwNjA+Iiti5GTQ0LAROLl
	qn5WCFtM4sK99UBxLg4hgWWMEqeerWWHKdo2fy0jRGI6o8Tadd2sEM5vRomXr9rAqtgE1CS+
	fDkMZosIeEtMeHyJGaSIWWAno8Tv5r/sEB3tjBJXW5cwdTFycHAKeEqcXc4L0iAs4CWxuvEC
	I4jNIqAqsejoQzaQEl4BW4k3TwxBwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGaRcQkBd
	4tFfXYgTjCTuHz4BVSIise/FO7AHJAT+skts+jeVHWKVgMS3yYdYIHplJTYdYIZ4WFLi4Iob
	LBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQmJ64g/H+
	AetDjMlA6ycyS4km5wNTQl5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MDJUv91dxFzbkRd/xbIqI7VG3++fo+LOu0pWx56J3v766akx77n+hnzj
	K+bh8UvdrxdrMWs8am/+Y6B58LhJV0CujoQG19ftLH0XZ/f5TOF+vVBUyuMqx/XAX3/cc+wP
	TAhfeUBZm2fiTnHezymCF/hTf3i/FPdIkrT689MzNO76YbMD7/8tU2Ipzkg01GIuKk4EAAlk
	OLH/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV0ui33BBvdumFicXXaQzaLtykF2
	i8sLL7FaXHjaw2ZxedccNosZ5/cxWVy5dIrNouXrORaLVbv+MDpwesxuuMjisXPWXXaPvi2r
	GD2O39jO5PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6q
	rZKLT4CuW2YO0EVKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoy10+4z
	FlzmqPj4qoGxgfERWxcjJ4eEgInEtvlrGSFsMYkL99YDxbk4hASmM0qsXdfNCuH8ZpR4+aqN
	HaSKTUBN4suXw2C2iIC3xITHl5hBipgFdjJK/G7+yw7R0c4ocbV1CVMXIwcHp4CnxNnlvCAN
	wgJeEqsbL4CtYxFQlVh09CEbSAmvgK3EmyeGIGFeAUGJH5PvsYDYzAJaEut3HmeCsOUlNq95
	ywxSLiGgLvHory7ECUYS9w+fgCoRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJEZwwnknvYFzVYHGIUYCDUYmHt6Fnb7AQa2JZcWXuIUYJDmYl
	EV6P/0Ah3pTEyqrUovz4otKc1OJDjKZAf05klhJNzgcms7ySeENjEzMjSyMzCyMTc3Mlcd6D
	rdaBQgLpiSWp2ampBalFMH1MHJxSDYxrfjnt6Lt1p2zdsuq/syYvfDpP+egkjp2zJXYKH6jy
	OiJQL2L6o+VhZZxxe05h4iHmWcWs++ui306x//tR7Mb1kpVrTx5dderu/V/cPMfV14dqxfNV
	591o2LV2eeLpZhPXqUXizLeu1+nphQobvLTM2hHy/U94ytv1VWdNotXfGt/eKMI3ffIJJZbi
	jERDLeai4kQAIQJEKS4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 8:49 PM, Sachin Kamat wrote:
> 
> USB DWC3 driver on Exynos platform does not work without its
> corresponding phy driver. Hence make the PHY driver depend on
> Exynos DWC3 driver and default it to yes to make things easier
> for the end user.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> No changes since v1.
> ---
>  drivers/phy/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 128f8b92b55c..ee6c80a5392a 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -152,8 +152,10 @@ config PHY_EXYNOS5_USBDRD
>  	tristate "Exynos5 SoC series USB DRD PHY driver"
>  	depends on ARCH_EXYNOS5 && OF
>  	depends on HAS_IOMEM
> +	depends on USB_DWC3_EXYNOS
>  	select GENERIC_PHY
>  	select MFD_SYSCON
> +	default y
>  	help
>  	  Enable USB DRD PHY support for Exynos 5 SoC series.
>  	  This driver provides PHY interface for USB 3.0 DRD controller
> --
> 1.7.9.5

