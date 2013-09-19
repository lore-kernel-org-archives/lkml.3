Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3ISVPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:15:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34399 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3ISVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:15:12 -0400
Date: Thu, 19 Sep 2013 16:14:09 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/3] PM / OPP: rename to dev_pm_opp * equivalents
Message-ID: <20130919211409.GA17419@kahuna>
References: <1379624632-17356-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1379624632-17356-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:03-20130919, Nishanth Menon wrote:
> Hi,
> 
> Based on [1], Randy rightly pointed out that OPP functions and data
> structures could be a bit specific to Power management.
> 
> So, the following series is based on v3.12-rc1 tag.
> 
> If folks like it broken in a different way, I am open to suggestions.
> 
> Nishanth Menon (3):
>   PM / OPP: rename functions to dev_pm_opp*
>   PM / OPP: rename data structures to dev_pm equivalents
>   PM / OPP: rename header to linux/pm_opp.h
> 
>  Documentation/power/opp.txt             |  108 ++++++++++++------------
>  arch/arm/mach-imx/mach-imx6q.c          |    4 +-
>  arch/arm/mach-omap2/board-omap3beagle.c |   10 +--
>  arch/arm/mach-omap2/omap-pm.h           |    2 +-
>  arch/arm/mach-omap2/opp.c               |    6 +-
>  arch/arm/mach-omap2/pm.c                |    8 +-
>  drivers/base/power/opp.c                |  115 ++++++++++++-------------
>  drivers/cpufreq/arm_big_little.c        |    8 +-
>  drivers/cpufreq/arm_big_little_dt.c     |    2 +-
>  drivers/cpufreq/cpufreq-cpu0.c          |   24 +++---
>  drivers/cpufreq/exynos5440-cpufreq.c    |   17 ++--
>  drivers/cpufreq/imx6q-cpufreq.c         |   26 +++---
>  drivers/cpufreq/omap-cpufreq.c          |   12 +--
>  drivers/devfreq/devfreq.c               |   25 +++---
>  drivers/devfreq/exynos/exynos4_bus.c    |   29 +++----
>  drivers/devfreq/exynos/exynos5_bus.c    |   28 +++----
>  include/linux/devfreq.h                 |    6 +-
>  include/linux/opp.h                     |  134 -----------------------------
>  include/linux/pm_opp.h                  |  139 +++++++++++++++++++++++++++++++
>  19 files changed, 357 insertions(+), 346 deletions(-)
>  delete mode 100644 include/linux/opp.h
>  create mode 100644 include/linux/pm_opp.h
> 
> -- 
> 1.7.9.5
> 
Oops.. seems I deleted the link of the discussion - my bad...
[1] http://marc.info/?t=137579467400007&r=1&w=2
-- 
Regards,
Nishanth Menon
