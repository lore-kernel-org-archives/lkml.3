Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3LXCwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:52:08 -0500
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:35664
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758202Ab3LXCwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:52:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kz8dhz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Tue, 24 Dec 2013 10:57:26 +0800
From: Robin Gong <b38343@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regulator: Kconfig: Improve PFUZE100 entry text
Message-ID: <20131224025725.GD27081@Robin-OptiPlex-780>
References: <1387827335-10109-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387827335-10109-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Robin gong <yibin.gong@freescale.com>

On Mon, Dec 23, 2013 at 05:35:35PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Make PFUZE100 entry consistent with other Freescale PMIC entries, so that now
> we can have:
> 
> 	<*>   Freescale MC13783 regulator driver
> 	<*>   Freescale MC13892 regulator driver 
> 	<*>   Freescale PFUZE100 regulator driver
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/regulator/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 7faedb7..8fe18bf 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -391,7 +391,7 @@ config REGULATOR_PCF50633
>  	 on PCF50633
>  
>  config REGULATOR_PFUZE100
> -	tristate "Support regulators on Freescale PFUZE100 PMIC"
> +	tristate "Freescale PFUZE100 regulator driver"
>  	depends on I2C
>  	select REGMAP_I2C
>  	help
> -- 
> 1.8.1.2
> 
> 
> 

