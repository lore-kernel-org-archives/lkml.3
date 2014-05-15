Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaEOJGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:06:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:27457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaEOJGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="512047004"
Message-ID: <1400144805.2273.34.camel@rzhang1-toshiba>
Subject: Re: [PATCH 00/10] thermal: exynos: various cleanups
From: Zhang Rui <rui.zhang@intel.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 17:06:45 +0800
In-Reply-To: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2014-05-05 at 13:15 +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series contains various cleanups for EXYNOS thermal
> driver.  Overall it decreases driver's LOC by 13%.  It is based
> on next-20140428 kernel.  It should not cause any functionality
> changes.
> 
Amit,

what do you think of this patch set?

thanks,
rui
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> Bartlomiej Zolnierkiewicz (10):
>   thermal: exynos: remove unused struct exynos_tmu_registers entries
>   thermal: exynos: remove unused defines
>   thermal: exynos: remove dead code for HW_MODE calibration
>   thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
>     calibration
>   thermal: exynos: remove redundant pdata checks from
>     exynos_tmu_initialize()
>   thermal: exynos: remove redundant threshold_code checks from
>     exynos_tmu_initialize()
>   thermal: exynos: simplify temp_to_code() and code_to_temp()
>   thermal: exynos: cache non_hw_trigger_levels in pdata
>   thermal: exynos: remove redundant pdata checks from
>     exynos_tmu_control()
>   thermal: exynos: remove identical values from exynos*_tmu_registers
>     structures
> 
>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
>  drivers/thermal/samsung/exynos_tmu.c            | 181 ++++--------------------
>  drivers/thermal/samsung/exynos_tmu.h            |  86 +----------
>  drivers/thermal/samsung/exynos_tmu_data.c       |  40 +-----
>  drivers/thermal/samsung/exynos_tmu_data.h       |  32 +----
>  5 files changed, 37 insertions(+), 303 deletions(-)
> 


