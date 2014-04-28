Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaD1LVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:21:10 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:42717 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaD1LVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:21:07 -0400
Date: Mon, 28 Apr 2014 12:21:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH v2 2/3] ARM: EXYNOS: Move pmu specific header files
 under "linux/mfd/samsung"
Message-ID: <20140428112101.GS21279@lee--X1>
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
 <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
 <1398431131-5946-3-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398431131-5946-3-git-send-email-pankaj.dubey@samsung.com>
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
>  arch/arm/mach-exynos/cpuidle.c              |    4 +-
>  arch/arm/mach-exynos/exynos-pmu.h           |   31 ---
>  arch/arm/mach-exynos/exynos.c               |    2 +-
>  arch/arm/mach-exynos/hotplug.c              |    2 +-
>  arch/arm/mach-exynos/platsmp.c              |    2 +-
>  arch/arm/mach-exynos/pm.c                   |    4 +-
>  arch/arm/mach-exynos/pmu.c                  |    5 +-
>  arch/arm/mach-exynos/regs-pmu.h             |  308 ---------------------------
>  include/linux/mfd/samsung/exynos-pmu.h      |   31 +++
>  include/linux/mfd/samsung/exynos-regs-pmu.h |  308 +++++++++++++++++++++++++++
>  10 files changed, 348 insertions(+), 349 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/exynos-pmu.h
>  delete mode 100644 arch/arm/mach-exynos/regs-pmu.h
>  create mode 100644 include/linux/mfd/samsung/exynos-pmu.h
>  create mode 100644 include/linux/mfd/samsung/exynos-regs-pmu.h

Can you resubmit this using the -M option for format-patch please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
