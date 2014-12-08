Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaLHMtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:49:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:43649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaLHMtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:49:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="426457731"
Date: Mon, 8 Dec 2014 18:19:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@kernel.org>, linux@arm.linux.org.uk, nsekhar@ti.com,
        arnd@arndb.de, khilman@deeprootsystems.com,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, chris@printf.net,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: edma: Split up header file to platform_data and
 API file
Message-ID: <20141208124917.GI16827@intel.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
 <1417084891-17990-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417084891-17990-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 12:41:31PM +0200, Peter Ujfalusi wrote:
> include/linux/platform_data/ is not a correct place to keep the API
> definitions for edma, it is meant to be only for the pdata for the device.
> Clean up this by moving the API to include/linux/edma.h
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/common/edma.c                     |   3 +-
>  arch/arm/mach-davinci/devices.c            |   1 +
>  arch/arm/mach-davinci/include/mach/da8xx.h |   1 +
>  drivers/dma/edma.c                         |   2 +-
>  include/linux/edma.h                       | 153 +++++++++++++++++++++++++++++
>  include/linux/platform_data/edma.h         | 148 ++--------------------------
>  sound/soc/davinci/davinci-pcm.h            |   1 +
>  7 files changed, 165 insertions(+), 144 deletions(-)
>  create mode 100644 include/linux/edma.h
I was hoping that this will have delete for platform_data/edma.h, do we
still need that and why shouldn't we get rid of this :)

-- 
~Vinod

