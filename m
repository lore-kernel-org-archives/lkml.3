Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbbAGN1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:27:47 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10204 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbAGN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:27:46 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-dc-54ad3450b339
Content-transfer-encoding: 8BIT
Message-id: <1420637261.32552.4.camel@AMDC1943>
Subject: Re: [PATCH v2] ARM: exynos_defconfig: Enable CONFIG_LOCKUP_DETECTOR
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Jan 2015 14:27:41 +0100
In-reply-to: <1420635542-7202-1-git-send-email-moon.linux@yahoo.com>
References: <1420635542-7202-1-git-send-email-moon.linux@yahoo.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xa7oBJmtDDBr3GFmcXXaQzeLo7wKL
	/sevmS2+Hl7BaLHp8TVWi8u75rBZzDi/j8ni9mVei+v3pzFbPF7xlt3iyqVTbBbTj79ltWj/
	u5fNgdejpbmHzWN2w0UWj7/Pr7N4LN7zkslj06pONo871/aweWxeUu/Rt2UVo8fnTXIes2Yd
	ZgrgiuKySUnNySxLLdK3S+DKOH7mP2PBG66KdW82sTUwtnN2MXJySAiYSHz+PY8VwhaTuHBv
	PVsXIxeHkMBSRom/v06zgCR4BQQlfky+B2RzcDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJJ4ca
	2SHq9SV2//jFBGILC/hInLg9E2wOm4CxxOblS9hAbBEBVYkHrVdZQZqZBX4yS6yc+x0swQKU
	mP77DZjNKeAicepgIyPIYiEBZ4lzE6xATAkBZYnGfrcJjAKzkFw3C+G6WUiuW8DIvIpRNLU0
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjJJK+7mBceszqEKMAB6MSD6/C5DUhQqyJZcWVuYcYJTiY
	lUR43/wCCvGmJFZWpRblxxeV5qQWH2Jk4uCUamDkrOb6mjPH/x/Thp7vsyaszO7iaZNPFY85
	cSRX2ie47PtXntCSckm5LaY3fkeu8mX4ueH8Es9H74pEal/Pfs/+vd3tfmOh24JFyw+LOTxb
	mLjd5EX0Y+m+Az+jnWdcMk9pbK0p8nPx16la7L5x9RxjrdrtBicbC71DfAqes2VzvdrR8ifY
	y1KJpTgj0VCLuag4EQCmT9NDggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2015-01-07 at 18:29 +0530, Anand Moon wrote:
> Enable CONFIG_LOCKUP_DETECTOR to validate kernel locks state for exynos SOC.
> 
> Enabling CONFIG_LOCKUP_DETECTOR help validator tracks the 'state' of lock-classes,
> and it tracks dependencies between different lock-classes.
> The validator maintains a rolling proof that the state and
> the dependencies are correct.

Unfortunately this is not correct. Lockup detector does something else.
Please read the help/manual for LOCKUP_DETECTOR. You can find in
lib/Kconfig.debug (around line 667).

Best regards,
Krzysztof

> 
> Changes since v2:
>  * Made commit message more clear
>  * Corrected grammer in code comment
> 
> Tested on Exynos5422 ODROID XU3 board.
> 
> Signed-off-by: Anand Moon <moon.linux@yahoo.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/configs/exynos_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 5ef14de..ecd9987 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -178,6 +178,7 @@ CONFIG_PRINTK_TIME=y
>  CONFIG_DEBUG_FS=y
>  CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DEBUG_KERNEL=y
> +CONFIG_LOCKUP_DETECTOR=y
>  CONFIG_DETECT_HUNG_TASK=y
>  CONFIG_DEBUG_RT_MUTEXES=y
>  CONFIG_DEBUG_SPINLOCK=y

