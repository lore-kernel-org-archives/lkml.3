Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaJWFPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:15:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:43022 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaJWFPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:15:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,773,1406617200"; 
   d="scan'208";a="609767848"
Message-ID: <1414041345.2380.3.camel@rzhang1-toshiba>
Subject: Re: [GIT PULL] thermal-soc changes
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 23 Oct 2014 13:15:45 +0800
In-Reply-To: <20141021134941.GA4937@developer>
References: <20141021134941.GA4937@developer>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 二, 2014-10-21 at 09:49 -0400, Eduardo Valentin wrote:
> Hello Rui,
> 
> Here are a couple of changes that are in my tree. They include:
> - a few code refactoring improving the Exynos code base;
> - new feature on the Exynos code base (TRIMINFO and TRIMRELOAD);
> - a documentation of RCAR thermal; and
> - a fix in the of-thermal, regarding the proper usage of of APIs.
> 
what's their target?
please send me separate pull requests for different targets.

thanks,
rui
> They are based on your next branch.
> 
> BR,
> 
> Eduardo Valentin
> 
> The following changes since commit 6ceaf58abe25e86292152005c51169796bad3407:
> 
>   Merge branch 'int340x-thermal' of .git into next (2014-10-17 14:30:58 +0800)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git next
> 
> for you to fetch changes up to df67e40f51398fef8dd705dfe4e287ad9b10ba4b:
> 
>   thermal: fix multiple disbalanced device node counters (2014-10-21 08:05:50 -0400)
> 
> ----------------------------------------------------------------
> Bartlomiej Zolnierkiewicz (9):
>       thermal: exynos: remove unused struct exynos_tmu_registers entries
>       thermal: exynos: remove dead code for HW_MODE calibration
>       thermal: exynos: remove redundant pdata checks from exynos_tmu_initialize()
>       thermal: exynos: remove redundant threshold_code checks from exynos_tmu_initialize()
>       thermal: exynos: simplify temp_to_code() and code_to_temp()
>       thermal: exynos: cache non_hw_trigger_levels in pdata
>       thermal: exynos: remove redundant pdata checks from exynos_tmu_control()
>       thermal: exynos: remove identical values from exynos*_tmu_registers structures
>       thermal: samsung: Exynos5260 and Exynos5420 should not use TRIM_RELOAD flag
> 
> Chanwoo Choi (2):
>       thermal: exynos: Add support for many TRIMINFO_CTRL registers
>       thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250
> 
> Geert Uytterhoeven (1):
>       thermal: rcar: Add binding docs for new R-Car Gen2 SoCs
> 
> Vladimir Zapolskiy (1):
>       thermal: fix multiple disbalanced device node counters
> 
>  .../devicetree/bindings/thermal/rcar-thermal.txt   |   5 +-
>  drivers/thermal/of-thermal.c                       |  40 ++++--
>  drivers/thermal/samsung/exynos_thermal_common.h    |   2 +-
>  drivers/thermal/samsung/exynos_tmu.c               | 141 ++++++---------------
>  drivers/thermal/samsung/exynos_tmu.h               |  81 ++----------
>  drivers/thermal/samsung/exynos_tmu_data.c          |  83 ++++--------
>  drivers/thermal/samsung/exynos_tmu_data.h          |  39 +-----
>  7 files changed, 111 insertions(+), 280 deletions(-)


