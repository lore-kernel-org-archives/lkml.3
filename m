Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3ENF3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:29:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:40910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3ENF31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:29:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,667,1363158000"; 
   d="scan'208";a="336776957"
Date: Tue, 14 May 2013 10:24:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/2] dma: support Lynxpoint DMA
Message-ID: <20130514045423.GC27639@intel.com>
References: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:55:47AM +0300, Andy Shevchenko wrote:
> This is the rest of patch series related to ACPI DMA helpers and Lynxpoint DMAC.
> Patches are rebased against current Linus' tree and Vinod's branch for-linus.
> 
> Since v2:
>  - remove patches that are already in the Vinod's tree
>  - rebase on top of today's origin/master and Vinod's for-linus branch
>  - fix description in patch 2/2
Applied both, Thanks

--
~Vinod
> 
> I will be on vacation next week. Mika promised to help if anything happens to
> these patches.
> 
> Andy Shevchenko (1):
>   dma: acpi-dma: parse CSRT to extract additional resources
> 
> Rafael J. Wysocki (1):
>   ACPI / LPSS: register clock device for Lynxpoint DMA properly
> 
>  drivers/acpi/Makefile                  |    1 -
>  drivers/acpi/acpi_lpss.c               |   26 ++++-
>  drivers/acpi/csrt.c                    |  159 -----------------------------
>  drivers/acpi/internal.h                |    1 -
>  drivers/acpi/scan.c                    |    1 -
>  drivers/clk/x86/clk-lpt.c              |   15 ++-
>  drivers/dma/acpi-dma.c                 |  172 +++++++++++++++++++++++++++++++-
>  include/linux/acpi_dma.h               |    4 +
>  include/linux/platform_data/clk-lpss.h |    5 +
>  9 files changed, 211 insertions(+), 173 deletions(-)
>  delete mode 100644 drivers/acpi/csrt.c
> 
> -- 
> 1.7.10.4
> 
