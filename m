Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3G2Eo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:44:26 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:35515
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab3G2EoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:44:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Mon, 29 Jul 2013 12:48:59 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: pfuze100: Fix module alias prefix
Message-ID: <20130729044858.GA32141@Robin-OptiPlex-780>
References: <1375071569.4147.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375071569.4147.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Axel for the quick founding. The patch set is ok for me.
On Mon, Jul 29, 2013 at 12:19:29PM +0800, Axel Lin wrote:
> i2c drivers use "i2c:" prefix for module alias.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/pfuze100-regulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index cd136ff..e9e8ae3 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -451,4 +451,4 @@ module_i2c_driver(pfuze_driver);
>  
>  MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
>  MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
> -MODULE_ALIAS("pfuze100-regulator");
> +MODULE_ALIAS("i2c:pfuze100-regulator");
> -- 
> 1.8.1.2
> 
> 
> 
> 

