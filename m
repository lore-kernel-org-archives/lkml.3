Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3HYLcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 07:32:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:12657 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab3HYLcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 07:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="351325265"
Date: Sun, 25 Aug 2013 16:17:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linus.walleij@linaro.org, khilman@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: ste_dma: Fix warning when CONFIG_ARM_LPAE=y
Message-ID: <20130825104759.GK8091@intel.com>
References: <1377131642-19494-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377131642-19494-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:34:02PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> When CONFIG_ARM_LPAE=y the following build warning are generated:
> 
> drivers/dma/ste_dma40.c:3228:2: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3593:5: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
> 
> According to Documentation/printk-formats.txt '%pa' can be used to properly 
> print 'resource_size_t'.
> 
> Also, for printing memory region the '%pr' is more convenient.
Applied, Thanks

~Vinod
