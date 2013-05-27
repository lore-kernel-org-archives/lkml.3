Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab3E0Kna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:43:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:42371 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341Ab3E0Kn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="247167371"
Date: Mon, 27 May 2013 15:36:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: mxs-dma: Staticize mxs_dma_xlate
Message-ID: <20130527100626.GB30200@intel.com>
References: <1369424247-12439-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369424247-12439-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 04:37:27PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following sparse warning:
> 
> drivers/dma/mxs-dma.c:696:17: warning: symbol 'mxs_dma_xlate' was not declared. Should it be static?
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Applied, Thanks

--
~Vinod
> ---
>  drivers/dma/mxs-dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index b48a79c..7195930 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -693,7 +693,7 @@ static bool mxs_dma_filter_fn(struct dma_chan *chan, void *fn_param)
>  	return true;
>  }
>  
> -struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
> +static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
>  			       struct of_dma *ofdma)
>  {
>  	struct mxs_dma_engine *mxs_dma = ofdma->of_dma_data;
> -- 
> 1.8.1.2
> 
