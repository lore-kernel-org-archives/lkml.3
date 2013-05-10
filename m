Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3EJOaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:30:16 -0400
Received: from 13.mo5.mail-out.ovh.net ([87.98.182.191]:33441 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755941Ab3EJOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:30:13 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 10:30:12 EDT
Date: Fri, 10 May 2013 16:20:02 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] dmaengine: at_hdmac/trivial: correct typo in
 comment
Message-ID: <20130510142002.GL3041@game.jcrosoft.org>
References: <042cac60509755c1340d141315a9a8eb1965438a.1368191734.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <042cac60509755c1340d141315a9a8eb1965438a.1368191734.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 222083757811936108
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on all

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

On 15:19 Fri 10 May     , Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index e923cda..cd49420 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1120,7 +1120,7 @@ static int atc_alloc_chan_resources(struct dma_chan *chan)
>  		 */
>  		BUG_ON(!atslave->dma_dev || atslave->dma_dev != atdma->dma_common.dev);
>  
> -		/* if cfg configuration specified take it instad of default */
> +		/* if cfg configuration specified take it instead of default */
>  		if (atslave->cfg)
>  			cfg = atslave->cfg;
>  	}
> -- 
> 1.8.0
> 
