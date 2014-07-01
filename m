Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbaGACJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:09:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:54817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaGACJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:09:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,578,1400050800"; 
   d="scan'208";a="566356517"
Message-ID: <1404180553.8366.16.camel@rzhang1-toshiba>
Subject: Re: [PATCH v2 0/9] thermal: exynos: various cleanups
From: Zhang Rui <rui.zhang@intel.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@gmail.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Jul 2014 10:09:13 +0800
In-Reply-To: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo,

what do you think of this patch set?

thanks,
rui

On Tue, 2014-06-17 at 19:27 +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series contains various cleanups for EXYNOS thermal
> driver.  Overall it decreases driver's LOC by 12%.  It is based
> on next-20140617 kernel.  It should not cause any functionality
> changes.
> 
> Changes since v1:
> - synced patches against next-20140617
> - merged patch "thermal: exynos: remove unused defines" into
>   "thermal: exynos: remove unused struct exynos_tmu_registers
>   entries" one (per request from Eduardo)
> - improved patch descriptions for patches #1-5
> - fixed documentation for pdata->gain and pdata->reference_voltage
> - added Reviewed-by from Amit to patches #6, #7 and #10
> - added missing Acked-by from Kyungmin Park
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
> Bartlomiej Zolnierkiewicz (9):
>   thermal: exynos: remove unused struct exynos_tmu_registers entries
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
>  drivers/thermal/samsung/exynos_tmu.h            |  90 +-----------
>  drivers/thermal/samsung/exynos_tmu_data.c       |  64 +--------
>  drivers/thermal/samsung/exynos_tmu_data.h       |  33 +----
>  5 files changed, 41 insertions(+), 328 deletions(-)
> 


