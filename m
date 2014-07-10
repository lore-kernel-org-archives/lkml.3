Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaGJGuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:50:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16158 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaGJGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:50:18 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-03-53be379f8453
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kishon@ti.com, dianders@chromium.org,
        gautam.vivek@samsung.com, spk.linux@gmail.com, tomasz.figa@gmail.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404906569-28026-1-git-send-email-sachin.kamat@samsung.com>
In-reply-to: <1404906569-28026-1-git-send-email-sachin.kamat@samsung.com>
Subject: Re: [PATCH v2 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
Date: Thu, 10 Jul 2014 15:50:07 +0900
Message-id: <003901cf9c0b$2f98f380$8ecada80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+bbGYscM/6A7SlRf6oqitSsWCGUwAnqyeA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zfd355vuCDbp/6licXXaQzaLtykF2
	i8sLL7FaXHjaw2ZxedccNosZ5/cxWVy5dIrNouXrORaLVbv+MDpwesxuuMjisXPWXXaPvi2r
	GD2O39jO5PF5k1wAaxSXTUpqTmZZapG+XQJXxvfdXAXTpSoOnbrO2MB4VKSLkZNDQsBE4uWp
	RYwQtpjEhXvr2boYuTiEBJYxSnz61c4EU7T++T9miMQiRolzPa9YIJzfjBIfT/5lBqliE1CT
	+PLlMDuILSLgLTHh8SWwDmaBnYwSv5v/giWEBDwkNl05yAZicwp4Styffxxst7BAgMTErR/B
	algEVCUefnrEAmLzCthKvF2xlgnCFpT4MfkeWJxZQEti/c7jTBC2vMTmNW+BlnEAnaou8eiv
	LsQNRhJ3nsxnhygRkdj34h0jyD0SAj/ZJV4/W88KsUtA4tvkQywQvbISmw4wQ3wsKXFwxQ2W
	CYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkhM9+1gvHnA
	+hBjMtD6icxSosn5wJSQVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoY4zJXNjXKMp8NclZdOYVx3x9xl6dvdwuvkZCbuLQ6dpNILEPWSfm7nflv
	fKVe9yzvuKav7XnYzsh80o+bcfnZIbWL6k5veTO1at35h59nJdues5x5YlJ5UnBlaserAwl5
	LcsXp299/rju+rOpcbqWMiHb5Qqn8xr6OD+atuXAk8jEpX4yiYsvKLEUZyQaajEXFScCAFJm
	BWn/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd355vuCDf6t1rA4u+wgm0XblYPs
	FpcXXmK1uPC0h83i8q45bBYzzu9jsrhy6RSbRcvXcywWq3b9YXTg9JjdcJHFY+esu+wefVtW
	MXocv7GdyePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnfd3MV
	TJeqOHTqOmMD41GRLkZODgkBE4n1z/8xQ9hiEhfurWfrYuTiEBJYxChxrucVC4Tzm1Hi48m/
	YFVsAmoSX74cZgexRQS8JSY8vsQMUsQssJNR4nfzX7CEkICHxKYrB9lAbE4BT4n7848zgtjC
	AgESE7d+BKthEVCVePjpEQuIzStgK/F2xVomCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8BVrG
	AXSqusSjv7oQNxhJ3Hkynx2iRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwwngmtYNxZYPFIUYBDkYlHt6Gnr3BQqyJZcWVuYcYJTiYlUR4
	Pf4DhXhTEiurUovy44tKc1KLDzGaAj06kVlKNDkfmMzySuINjU3MjCyNzCyMTMzNlcR5D7Ra
	BwoJpCeWpGanphakFsH0MXFwSjUwTmWpfitnzcpvLbfM4KTnnHXRndf/FR3f8XDX1yL5Mm2V
	88dqXzJtaFrpM2e5R8jN2BaGEoUPc61V3y3aeLpNNmdf8x1jblY2mb/O566wvM7yuv5l4+EP
	OydpFG5RCVy6bXVp2IZAh13zeAyF5rMY2CV92D6N8XFjze1J2+S3NjTbHE+OVfl8XImlOCPR
	UIu5qDgRAKBf9UguAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 8:49 PM, Sachin Kamat wrote:
> 
> Since the USB 2.0 PHYs are required with EHCI/OHCI USB drivers and
> USB gadget controller supported by the DWC2 gadget driver, make it
> depend on them and default to ARCH_EXYNOS as they are meant for
> Exynos platforms. Also, make the sub-drivers silent options enabling
> them based on the SoC platforms that they are meant to work with. This
> will make life easier for end users who do not have any way knowing the
> dependencies.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> Changes since v1:
> * Added dependency on DWC2 gadget driver as suggested by Tomasz Figa.
> ---
>  drivers/phy/Kconfig |   35 +++++++++++------------------------
>  1 file changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index fcdfe7c0e4a7..128f8b92b55c 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -123,43 +123,30 @@ config PHY_SUN4I_USB
>  config PHY_SAMSUNG_USB2
>  	tristate "Samsung USB 2.0 PHY driver"
>  	depends on HAS_IOMEM
> +	depends on USB_EHCI_EXYNOS || USB_OHCI_EXYNOS || USB_DWC2
>  	select GENERIC_PHY
>  	select MFD_SYSCON
> +	default ARCH_EXYNOS
>  	help
>  	  Enable this to support the Samsung USB 2.0 PHY driver for Samsung
> -	  SoCs. This driver provides the interface for USB 2.0 PHY. Support for
> -	  particular SoCs has to be enabled in addition to this driver. Number
> -	  and type of supported phys depends on the SoC.
> +	  SoCs. This driver provides the interface for USB 2.0 PHY. Support
> +	  for particular PHYs will be enabled based on the SoC type in addition
> +	  to this driver.
> 
>  config PHY_EXYNOS4210_USB2
> -	bool "Support for Exynos 4210"
> +	bool
>  	depends on PHY_SAMSUNG_USB2
> -	depends on CPU_EXYNOS4210
> -	help
> -	  Enable USB PHY support for Exynos 4210. This option requires that
> -	  Samsung USB 2.0 PHY driver is enabled and means that support for this
> -	  particular SoC is compiled in the driver. In case of Exynos 4210 four
> -	  phys are available - device, host, HSIC0 and HSIC1.
> +	default CPU_EXYNOS4210
> 
>  config PHY_EXYNOS4X12_USB2
> -	bool "Support for Exynos 4x12"
> +	bool
>  	depends on PHY_SAMSUNG_USB2
> -	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
> -	help
> -	  Enable USB PHY support for Exynos 4x12. This option requires that
> -	  Samsung USB 2.0 PHY driver is enabled and means that support for this
> -	  particular SoC is compiled in the driver. In case of Exynos 4x12 four
> -	  phys are available - device, host, HSIC0 and HSIC1.
> +	default SOC_EXYNOS4212 || SOC_EXYNOS4412
> 
>  config PHY_EXYNOS5250_USB2
> -	bool "Support for Exynos 5250"
> +	bool
>  	depends on PHY_SAMSUNG_USB2
> -	depends on SOC_EXYNOS5250
> -	help
> -	  Enable USB PHY support for Exynos 5250. This option requires that
> -	  Samsung USB 2.0 PHY driver is enabled and means that support for this
> -	  particular SoC is compiled in the driver. In case of Exynos 5250 four
> -	  phys are available - device, host, HSIC0 and HSIC.
> +	default SOC_EXYNOS5250 || SOC_EXYNOS5420
> 
>  config PHY_EXYNOS5_USBDRD
>  	tristate "Exynos5 SoC series USB DRD PHY driver"
> --
> 1.7.9.5

