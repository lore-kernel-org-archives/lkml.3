Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3E0HHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:07:23 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:32927
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756585Ab3E0HHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:07:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hz8dhz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 27 May 2013 15:07:01 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: mxs-dma: Staticize mxs_dma_xlate
Message-ID: <20130527070659.GH7782@S2101-09.ap.freescale.net>
References: <1369424247-12439-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369424247-12439-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
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

Acked-by: Shawn Guo <shawn.guo@linaro.org>

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

