Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3JOLgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:36:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:53392 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912Ab3JOLgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="417060120"
Message-ID: <1381837008.2080.61.camel@rzhang1-mobl4>
Subject: Re: [GIT PULL] thermal-soc: urgent fixes for 3.12
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: amit.daniel@samsung.com, l.majewski@samsung.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 15 Oct 2013 19:36:48 +0800
In-Reply-To: <1381788001-3508-1-git-send-email-eduardo.valentin@ti.com>
References: <1381788001-3508-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eduardo,

On Mon, 2013-10-14 at 18:00 -0400, Eduardo Valentin wrote:
> Hello Rui,
> 
> Please pull the following changes. It contains fixes for 3.12 on Exynos
> thermal driver, which is currently broken, Exynos4412 is the main affected.
> Thanks Lukasz for his persistence on getting this done for 3.12.
> 
> Lukasz, you need to queue the remaining changes on DT via your platform tree.
> 
> It contains also a fix on the extrapolation rules for TI SoCs.
> 
> The following changes since commit 74ae45a3d656d3e86bb8e776634ebdfd3f39f37c:
> 
>   Merge branches 'x86_pkg_temp' and 'misc' of .git into next (2013-09-25 21:41:44 +0800)
> 
please rebase your tree on top of my master branch or Linus' tree.
Or else I'll pull in some thermal changes in my next branch that are
targeted for 3.13.

thanks,
rui
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git next
> 
> for you to fetch changes up to 848a3b2b91a45f6b7814e2779f58cc0461d88fce:
> 
>   drivers: thermal: allow ti-soc-thermal run without pcb zone (2013-10-14 17:48:33 -0400)
> 
> ----------------------------------------------------------------
> Eduardo Valentin (1):
>       drivers: thermal: allow ti-soc-thermal run without pcb zone
> 
> Lukasz Majewski (3):
>       thermal: exynos: Remove check for thermal device pointer at exynos_report_trigger()
>       thermal: exynos: Provide separate TMU data for Exynos4412
>       thermal: exynos: Provide initial setting for TMU's test MUX address at Exynos4412
> 
>  drivers/thermal/samsung/exynos_thermal_common.c    |  2 --
>  drivers/thermal/samsung/exynos_tmu.c               | 12 ++++++---
>  drivers/thermal/samsung/exynos_tmu.h               |  7 ++++-
>  drivers/thermal/samsung/exynos_tmu_data.c          | 30 +++++++++++++++++-----
>  drivers/thermal/samsung/exynos_tmu_data.h          | 13 +++++++++-
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  1 +
>  6 files changed, 51 insertions(+), 14 deletions(-)


