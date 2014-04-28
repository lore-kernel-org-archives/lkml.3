Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaD1MRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:17:15 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34067 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbaD1MRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:17:11 -0400
Date: Mon, 28 Apr 2014 13:17:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RESUBMIT RFC PATCH v2 2/3] ARM: EXYNOS: Move pmu specific
 header files under "linux/mfd/samsung"
Message-ID: <20140428121704.GD21279@lee--X1>
References: <1398687607-4554-1-git-send-email-pankaj.dubey@samsung.com>
 <1398687607-4554-3-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398687607-4554-3-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Moving Exynos PMU specific header file into "include/linux/mfd/samsung"
> thus updated affected files under "mach-exynos" to use new location of
> these header files.
> 
> CC: Sangbeom Kim <sbkim73@samsung.com>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/cpuidle.c                                    |    4 ++--
>  arch/arm/mach-exynos/exynos.c                                     |    2 +-
>  arch/arm/mach-exynos/hotplug.c                                    |    2 +-
>  arch/arm/mach-exynos/platsmp.c                                    |    2 +-
>  arch/arm/mach-exynos/pm.c                                         |    4 ++--
>  arch/arm/mach-exynos/pmu.c                                        |    5 ++---
>  {arch/arm/mach-exynos => include/linux/mfd/samsung}/exynos-pmu.h  |    0
>  .../regs-pmu.h => include/linux/mfd/samsung/exynos-regs-pmu.h     |    0
>  8 files changed, 9 insertions(+), 10 deletions(-)
>  rename {arch/arm/mach-exynos => include/linux/mfd/samsung}/exynos-pmu.h (100%)
>  rename arch/arm/mach-exynos/regs-pmu.h => include/linux/mfd/samsung/exynos-regs-pmu.h (100%)

Patch looks okay to me.

With an Exynos Ack I'd like to take it through the MFD tree.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
