Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3K1JJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:09:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:50865 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab3K1JJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:09:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="443586010"
Date: Thu, 28 Nov 2013 13:41:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: andrew.liu200917@gmail.com
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edma: free the same memory twice
Message-ID: <20131128081158.GX8834@intel.com>
References: <1385139243-5892-1-git-send-email-andrew.liu200917@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385139243-5892-1-git-send-email-andrew.liu200917@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 12:54:03AM +0800, andrew.liu200917@gmail.com wrote:
> From: Andrew Liu <andrew.liu200917@gmail.com>
> 
> Signed-off-by: Andrew Liu <andrew.liu200917@gmail.com>

This is already fixed in Linus tree via commit commit b6d5050

--
~Vinod
> ---
>  drivers/dma/edma.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index bef8a36..04bc1be 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -305,7 +305,6 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
>  						EDMA_SLOT_ANY);
>  			if (echan->slot[i] < 0) {
> -				kfree(edesc);
>  				dev_err(dev, "Failed to allocate slot\n");
>  				kfree(edesc);
>  				return NULL;
> -- 
> 1.7.9
> 

-- 
