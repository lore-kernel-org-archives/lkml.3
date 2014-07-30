Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaG3Nww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:52:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:36082 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbaG3Nwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:52:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="scan'208";a="463156559"
Date: Wed, 30 Jul 2014 19:14:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 0/3] dmaengine: sun6i: Misc fixes for the dma driver
Message-ID: <20140730134441.GL8181@intel.com>
References: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:30:20AM +0200, Maxime Ripard wrote:
> Hi Dan, Vinod,
> 
> Here are the patches that you requested previously, plus an additional
> fix for a memory leak was spotted by Dan Carpenter.

Applied, thanks

-- 
~Vinod
> 
> Thanks,
> Maxime
> 
> Maxime Ripard (3):
>   dmaengine: sun6i: Remove switch statement from buswidth convertion
>     routine
>   dmaengine: sun6i: Free the interrupt before killing the tasklet
>   dmaengine: sun6i: Fix memory leaks
> 
>  drivers/dma/sun6i-dma.c | 40 +++++++++++++++++-----------------------
>  1 file changed, 17 insertions(+), 23 deletions(-)
> 
> -- 
> 2.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
