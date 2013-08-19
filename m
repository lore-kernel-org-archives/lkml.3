Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab3HSJ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:58:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:8275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3HSJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,912,1367996400"; 
   d="scan'208";a="364797925"
Date: Mon, 19 Aug 2013 14:45:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/25] dma: of: make error message more meaningful by
 adding the node name
Message-ID: <20130819091527.GA5810@intel.com>
References: <1375280075-18482-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375280075-18482-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:14:35PM +0200, Lothar Waﬂmann wrote:
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
Applied, thanks

~Vinod
> ---
>  drivers/dma/of-dma.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 75334bd..0b88dd3 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -160,7 +160,8 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
>  
>  	count = of_property_count_strings(np, "dma-names");
>  	if (count < 0) {
> -		pr_err("%s: dma-names property missing or empty\n", __func__);
> +		pr_err("%s: dma-names property of node '%s' missing or empty\n",
> +			__func__, np->full_name);
>  		return NULL;
>  	}
>  
> -- 
> 1.7.2.5
> 

-- 
