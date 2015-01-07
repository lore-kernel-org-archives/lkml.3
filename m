Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbbAGMWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:22:35 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62891 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbAGMWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:22:33 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-1f-54ad25072662
Content-transfer-encoding: 8BIT
Message-id: <1420633348.32552.2.camel@AMDC1943>
Subject: Re: [PATCH] ARM: exynos_defconfig: Enable CONFIG_LOCKUP_DETECTOR
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Jan 2015 13:22:28 +0100
In-reply-to: <1420632932-6964-1-git-send-email-moon.linux@yahoo.com>
References: <1420632932-6964-1-git-send-email-moon.linux@yahoo.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xq7rsqmtDDN5MVLE4u+wgm0XblYPs
	Fkd/F1j0P37NbPH18ApGi02Pr7FaXN41h81ixvl9TBa3L/NaXL8/jdni8Yq37BZXLp1is2j/
	u5fNgdejpbmHzWN2w0UWj7/Pr7N4LN7zkslj06pONo871/aweWxeUu/Rt2UVo8fnTXIes2Yd
	ZgrgiuKySUnNySxLLdK3S+DK2HZ9NlvBY+6Ky7vdGhjvcHYxcnJICJhI9Pa/ZoawxSQu3FvP
	1sXIxSEksJRR4sutZUwgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJnusT
	GSHq9SU6vu1hAqkXFvCUOLyMFyTMJmAssXn5EjYQW0RAVeJB61VWkF5mgc/MEmvX9YL1sgAl
	etbPADuIU8BF4vr2u2BxIQFnica3U8FmSggoSzT2u01gFJiF5LpZCNfNQnLdAkbmVYyiqaXJ
	BcVJ6blGesWJucWleel6yfm5mxghcfR1B+PSY1aHGAU4GJV4eBUmrwkRYk0sK67MPcQowcGs
	JML75hdQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+Pi+sPnzgQmnZv77AHX92MBwntPbDCLL5je
	8eBmU7BtN7vtK/7KM8Gnda/7VyaYTf/bdMB+NtfMHVtecIr2zP/5LndpJufUUsPH68X/RwVm
	FsbqCj9LLRTneWLUt8J8kz5bwWGucuXcmPUnXsRuc+3SMj06+2FG7LY7Go1rNx2bL5Due4/1
	uqoSS3FGoqEWc1FxIgDPl2TsgQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2015-01-07 at 17:45 +0530, Anand Moon wrote:
> ARM Enable CONFIG_LOCKUP_DETECTOR to validation of kernel locks
> 
> v2 Fixed the commit log
> This config item helps getting some useful information when lockup
> happens. If you want to validate locks then probably you want
> PROVE_LOCKING... but its overhead is larger.
> 
> Anyway the overhead of LOCKUP_DETECTOR is small and multi_v7_defconfig
> has it enabled so I guess exynos may do it as well.

Err? Why did you include my response as commit message? It does not
really make sense.

Let me point this once again:
1. The commit message is inaccurate because CONFIG_LOCKUP_DETECTOR does
not validate the locks.
2. Please write proper commit message describing WHY you want to add
this config option.

Best regards,
Krzysztof

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

