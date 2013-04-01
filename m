Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3DAGzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:55:49 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:8325
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756725Ab3DAGzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:55:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 1 Apr 2013 14:56:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pwm: mxs: Remove unused *dev from struct mxs_pwm_chip
Message-ID: <20130401065603.GG1693@S2101-09.ap.freescale.net>
References: <1364784493.7725.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364784493.7725.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:48:13AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/pwm/pwm-mxs.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
> index a53d309..23d5180 100644
> --- a/drivers/pwm/pwm-mxs.c
> +++ b/drivers/pwm/pwm-mxs.c
> @@ -38,7 +38,6 @@
>  
>  struct mxs_pwm_chip {
>  	struct pwm_chip chip;
> -	struct device *dev;
>  	struct clk *clk;
>  	void __iomem *base;
>  };
> @@ -166,7 +165,6 @@ static int mxs_pwm_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	mxs->dev = &pdev->dev;
>  	platform_set_drvdata(pdev, mxs);
>  
>  	stmp_reset_block(mxs->base);
> -- 
> 1.7.10.4
> 
> 
> 

