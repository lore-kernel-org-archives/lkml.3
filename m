Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaJ1LGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:06:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63186 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaJ1LGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:06:43 -0400
X-AuditID: cbfee68e-f79b46d000002b74-e5-544f78c029cd
From: Kukjin Kim <kgene@kernel.org>
To: "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1414401440-10972-1-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1414401440-10972-1-git-send-email-javier.martinez@collabora.co.uk>
Subject: RE: [PATCH 1/1] ARM: exynos_defconfig: Enable max77802 rtc and clock
 drivers
Date: Tue, 28 Oct 2014 20:06:40 +0900
Message-id: <04e101cff29f$4021ea00$c065be00$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMMI3oWe31rdi2D+0kRRwLUDJpawZnM9w1Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd0DFf4hBnO7zCzOLjvIZnH0d4HF
	18MrGC02Pb7GanF51xw2ixnn9zE5sHnMbrjI4vH3+XUWjzvX9rB5bF5S7/F5k1wAaxSXTUpq
	TmZZapG+XQJXxurFRgVX+SuufrzI1MD4maeLkZNDQsBE4sfjd6wQtpjEhXvr2boYuTiEBJYx
	Spw++psVpmj9h93sEIlFjBKHjy9mhXD+MkqcvdXN3MXIwcEmoCzR2KQP0iAsoCWxcEsTC4gt
	IuAgcf7FaTYQm1lgN6PEmWYLEFtIwF9izf09TCA2p0CAxJMH/awQveESv55eZQSxWQRUJT78
	nQQ2h1fAQmLayRPMELagxI/J91ggZmpJrN95nAnClpfYvOYtM8TRChI7zr5mhLjBSOLgyZfM
	EDUiEvtevGMEuV9C4CO7xIzJF9ghlglIfJt8iAXkFwkBWYlNB6DmSEocXHGDZQKj5Cwkq2ch
	WT0LyepZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESx307GG8esD7EKMDBqMTD
	a/DQL0SINbGsuDL3EKMp0EUTmaVEk/OBySKvJN7Q2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGOXNl5R5z8Dj0bZL5nP1gv0v7/cU8q/9lOoSaHrrC9XmJ
	+APrxReu+iQsj7pwn/3zjyUzG848Lz10zcZVWsh456aDkQphP2wzqrbbZvJv2XRA2faydf3p
	P+9+KJzl/2G1/OUjJf23pf6i5RfmFCS/MvAQfPzZ44R6ccVfW/Em1Wert7dv2COmo8RSnJFo
	qMVcVJwIALdrvFDeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd0DFf4hBq+ajSzOLjvIZnH0d4HF
	18MrGC02Pb7GanF51xw2ixnn9zE5sHnMbrjI4vH3+XUWjzvX9rB5bF5S7/F5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozVi40KrvJXXP14kamB8TNPFyMnh4SA
	icT6D7vZIWwxiQv31rN1MXJxCAksYpQ4fHwxK4Tzl1Hi7K1u5i5GDg42AWWJxiZ9kAZhAS2J
	hVuaWEBsEQEHifMvTrOB2MwCuxklzjRbgNhCAv4Sa+7vYQKxOQUCJJ486GeF6A2X+PX0KiOI
	zSKgKvHh7ySwObwCFhLTTp5ghrAFJX5MvscCMVNLYv3O40wQtrzE5jVvmSGOVpDYcfY1I8QN
	RhIHT75khqgRkdj34h3jBEbhWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJEZwknknvYFzVYHGIUYCDUYmH1/ChX4gQa2JZcWXuIUYJDmYlEd6IGP8QId6UxMqq
	1KL8+KLSnNTiQ4ymQJ9OZJYSTc4HJrC8knhDYxMzI0sjMwsjE3NzJXHeg63WgUIC6Yklqdmp
	qQWpRTB9TBycUg2MeuYln5KnmsaI9s5+PTnt6YJUsV27ArVXbvv/QFMiY8HX8L/35ujJaazO
	vXpF6+Ts6/GTX1kZJz+TDZ1z01dI/SV/sv6qY1xl5zibCmpT5tyqm/Fy/s8oPlljkf/rVz1+
	9Gq25I9Nl8/enl59YWbYi+8fWOw6b7owP5xxypb5gWPKlbfTuWP3dyuxFGckGmoxFxUnAgDc
	go1/KAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier Martinez Canillas wrote:
> 
Hi,

> Commit 6e80e3d87549 ("ARM: exynos_defconfig: Enable MAX77802")
> enabled support for the max77802 regulators but the PMIC also
> has a Real-Time-Clock (RTC) and 2-channel 32kHz clock outputs.
> 
Yes, right.

> Enable the kernel config options to have the drivers for these
> devices built-in since they are present in many Exynos boards.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Acked-by: Kevin Hilman <khilman@linaro.org>
> Tested-by: Kevin Hilman <khilman@linaro.org>
> ---
> 
> This patch supersedes [0] since commit "ARM: exynos_defconfig: savedefconfig"
> is not present in linux-next anymore which disabled among other options, the
> max77802 support.
> 
Yeah, I talked about savedefconfig with Bart and I decided to revert it at that
time.

> However, support for the max77802 rtc and clocks were not enabled on exynos
> defconfig so $subject is still needed.
> 
> Kevin, I carried your tags from [0] since $subject enables the options you
> needed to get RTC wakeup from suspend working on exynos5800-peach-pi. Please
> let me know if they no longer applies.
> 
> Best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/10/9/413
> 
>  arch/arm/configs/exynos_defconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 72058b8..e21ef83 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -142,11 +142,13 @@ CONFIG_MMC_DW_IDMAC=y
>  CONFIG_MMC_DW_EXYNOS=y
>  CONFIG_RTC_CLASS=y
>  CONFIG_RTC_DRV_MAX77686=y
> +CONFIG_RTC_DRV_MAX77802=y
>  CONFIG_RTC_DRV_S5M=y
>  CONFIG_RTC_DRV_S3C=y
>  CONFIG_DMADEVICES=y
>  CONFIG_PL330_DMA=y
>  CONFIG_COMMON_CLK_MAX77686=y
> +CONFIG_COMMON_CLK_MAX77802=y
>  CONFIG_COMMON_CLK_S2MPS11=y
>  CONFIG_EXYNOS_IOMMU=y
>  CONFIG_IIO=y
> --
> 2.1.0

I'll apply this, thanks.

- Kukjin

