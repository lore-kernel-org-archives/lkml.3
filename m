Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab3BQICU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 03:02:20 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:30023
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148Ab3BQICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 03:02:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 17 Feb 2013 16:02:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] clk: mxs: Fix sparse warnings
Message-ID: <20130217080219.GF15048@S2101-09.ap.freescale.net>
References: <1360591636-10575-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1360591636-10575-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 12:07:16PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following sparse warnings:
> 
> drivers/clk/mxs/clk.c:17:1: warning: symbol 'mxs_lock' was not declared. Should it be static?
> drivers/clk/mxs/clk.c:19:5: warning: symbol 'mxs_clk_wait' was not declared. Should it be static?
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/clk/mxs/clk.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/mxs/clk.c b/drivers/clk/mxs/clk.c
> index b24d560..5301bce 100644
> --- a/drivers/clk/mxs/clk.c
> +++ b/drivers/clk/mxs/clk.c
> @@ -13,6 +13,7 @@
>  #include <linux/io.h>
>  #include <linux/jiffies.h>
>  #include <linux/spinlock.h>
> +#include "clk.h"
>  
>  DEFINE_SPINLOCK(mxs_lock);
>  
> -- 
> 1.7.9.5
> 

