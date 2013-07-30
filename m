Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab3G3DBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:01:55 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:17273
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab3G3DBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:01:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 30 Jul 2013 11:02:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Niels de Vos <ndevos@redhat.com>
CC: <devicetree@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] imx2_wdt: expose module alias for loading from
 device-tree
Message-ID: <20130730030211.GD19715@S2101-09.ap.freescale.net>
References: <1375083498-14822-1-git-send-email-ndevos@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375083498-14822-1-git-send-email-ndevos@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 09:38:18AM +0200, Niels de Vos wrote:
> Enable auto loading by udev when imx2_wdt is compiled as a module.
> 
> Signed-off-by: Niels de Vos <ndevos@redhat.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/watchdog/imx2_wdt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 693ac3f..17680aa 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -322,6 +322,7 @@ static const struct of_device_id imx2_wdt_dt_ids[] = {
>  	{ .compatible = "fsl,imx21-wdt", },
>  	{ /* sentinel */ }
>  };
> +MODULE_DEVICE_TABLE(of, imx2_wdt_dt_ids);
>  
>  static struct platform_driver imx2_wdt_driver = {
>  	.remove		= __exit_p(imx2_wdt_remove),
> -- 
> 1.7.11.7
> 

