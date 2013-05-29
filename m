Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab3E2Cse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:48:34 -0400
Received: from [207.46.163.27] ([207.46.163.27]:50198 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759366Ab3E2Csb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:48:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 29 May 2013 10:47:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mxs: Include clk mxs header file
Message-ID: <20130529024746.GD370@S2101-09.ap.freescale.net>
References: <1369668505-14499-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369668505-14499-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 12:28:25PM -0300, Fabio Estevam wrote:
> Fix the following sparse warnings:
> 
> drivers/clk/mxs/clk-imx28.c:72:5: warning: symbol 'mxs_saif_clkmux_select' was not declared. Should it be static?
> drivers/clk/mxs/clk-imx28.c:156:12: warning: symbol 'mx28_clocks_init' was not declared. Should it be static?
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/clk/mxs/clk-imx28.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
> index d0e5eed..4faf0af 100644
> --- a/drivers/clk/mxs/clk-imx28.c
> +++ b/drivers/clk/mxs/clk-imx28.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/clk/mxs.h>
>  #include <linux/clkdev.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> -- 
> 1.8.1.2
> 
> 

