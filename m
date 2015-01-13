Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbbAMISP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:18:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16370 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbAMISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:18:13 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-80-54b4d4c287cd
Message-id: <1421137088.8355.1.camel@AMDC1943>
Subject: Re: [PATCH v3] ARM: exynos_defconfig Enable CONFIG_LOCKUP_DETECTOR.
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Jan 2015 09:18:08 +0100
In-reply-to: <1421088614-4662-1-git-send-email-moon.linux@yahoo.com>
References: <1421088614-4662-1-git-send-email-moon.linux@yahoo.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xK7qHrmwJMVg9U9/i7LKDbBZtVw6y
	Wxz9XWDR//g1s8Wmx9dYLS7vmsNmMeP8PiaL25d5La7fn8Zs8XjFW3aLK5dOsVm0/93L5sDj
	0dLcw+Yxu+Eii8ff59dZPBbvecnksWlVJ5vHnWt72Dw2L6n36NuyitHj8yY5j1mzDjMFcEVx
	2aSk5mSWpRbp2yVwZbztsi44zlnxc+E+9gbGf+xdjJwcEgImEqtuNTBC2GISF+6tZ+ti5OIQ
	EljKKLFh+QFmCOczo8SURRNYQKp4BfQk1sxqYO1i5OAQFvCR2H1ZFyTMJmAssXn5EjYQW0RA
	VeJB61VWkF5mgQvMEp/fTWAGSbAAJb5e2McEYnMKuEhcmzudFcQWEnCWaG3eC9bMLKAuMWne
	ImaQ+RICyhKN/W4QawUlfky+xwJRIi+xec1b5gmMArOQdMxCUjYLSdkCRuZVjKKppckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGCER9GUH4+JjVocYBTgYlXh4d2RvCRFiTSwrrsw9xCjBwawkwms3
	ByjEm5JYWZValB9fVJqTWnyIkYmDU6qBUe2f3kWLsi6vfxsWzC/Oa6y1urXl3uH6i6f9T1Qz
	Vc55v+DYmeVuEkKvD/JoeZ05HNx1rPnOxbKXMv5HTuf8yG+aVRfQl77I+3/dJJcOo5yQ17Ma
	dlUI2zotd9qYdGSmfNS6H8LvpZtUchvlKrP+LF5WXH44JVd3QVKjpr96zpvPxe90rf6cV2Ip
	zkg01GIuKk4EAJuGmbN+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2015-01-13 at 00:20 +0530, Anand Moon wrote:
> On enabling CONFIG_LOCKUP_DETECTOR the kernel to act as a watchdog
> to detect hard and soft lockups. Enabling CONFIG_LOCKUP_DETECTOR
> don't introduce much overhead on exyons SOC.
> 
> CONFIG_LOCKUP_DETECTOR is enabled on multi_v7_defconfig.
> 
> Changes since v3:
>  * Made commit message more clear
>  * Corrected difference between CONFIG_LOCKUP_DETECTOR and CONFIG_LOCKDEP.
> 
> Tested on Exynos5422 ODROID XU3 board.
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Anand Moon <moon.linux@yahoo.com>

Now it looks okay. My reviewed-by may stay on.

Best regards,
Krzysztof

> ---
>  arch/arm/configs/exynos_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 5ef14de..64b2fe9 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -182,6 +182,7 @@ CONFIG_DETECT_HUNG_TASK=y
>  CONFIG_DEBUG_RT_MUTEXES=y
>  CONFIG_DEBUG_SPINLOCK=y
>  CONFIG_DEBUG_MUTEXES=y
> +CONFIG_LOCKUP_DETECTOR=y
>  CONFIG_DEBUG_INFO=y
>  CONFIG_DEBUG_USER=y
>  CONFIG_CRYPTO_SHA256=y

