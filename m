Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaH1OtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:49:17 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:39770 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaH1OtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:49:15 -0400
Date: Thu, 28 Aug 2014 10:49:22 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] thermal: exynos: various cleanups
Message-ID: <20140828144921.GB18194@developer>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit,

On Thu, Jul 31, 2014 at 07:10:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series contains various cleanups for EXYNOS thermal
> driver.  Overall it decreases driver's LOC by 9%.  It is based
> on next-20140731 kernel.  It should not cause any functionality
> changes.
> 

Did you have the time to test this series?

> Changes since v2 (https://lkml.org/lkml/2014/6/17/436):
> - synced patches against next-20140731
> - dropped patch "thermal: exynos: remove dead code for
>   TYPE_TWO_POINT_TRIMMING calibration" (newly added Exynos3250
>   SoC support uses TYPE_TWO_POINT_TRIMMING calibration)
> - updated patch description for patch #2
> - dropped Reviewed-by from Amit from patch #8 (due to changed
>   scope of the patch)
> 
> Changes since v1 (https://lkml.org/lkml/2014/5/5/194):
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
> Bartlomiej Zolnierkiewicz (8):
>   thermal: exynos: remove unused struct exynos_tmu_registers entries
>   thermal: exynos: remove dead code for HW_MODE calibration
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
>  drivers/thermal/samsung/exynos_tmu.c            | 126 +++++-------------------
>  drivers/thermal/samsung/exynos_tmu.h            |  74 +-------------
>  drivers/thermal/samsung/exynos_tmu_data.c       |  56 ++---------
>  drivers/thermal/samsung/exynos_tmu_data.h       |  31 +-----
>  5 files changed, 35 insertions(+), 253 deletions(-)
> 
> -- 
> 1.8.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
