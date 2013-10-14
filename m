Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3JNIy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:54:57 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:23343
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959Ab3JNIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:54:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 14 Oct 2013 16:55:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, "'Marek Vasut'" <marex@denx.de>
Subject: Re: [PATCH 02/11] regulator: anatop: Fix checkpatch issue
Message-ID: <20131014085540.GB27668@S2101-09.ap.freescale.net>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
 <000101cec8b9$c967efa0$5c37cee0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000101cec8b9$c967efa0$5c37cee0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:45:51PM +0900, Jingoo Han wrote:
> Fix the following checkpatch warning.
> 
>   WARNING: quoted string split across lines
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/regulator/anatop-regulator.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
> index e42bfd1..c734d09 100644
> --- a/drivers/regulator/anatop-regulator.c
> +++ b/drivers/regulator/anatop-regulator.c
> @@ -255,7 +255,7 @@ static void __exit anatop_regulator_exit(void)
>  }
>  module_exit(anatop_regulator_exit);
>  
> -MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>, "
> -	      "Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
> +MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>");
> +MODULE_AUTHOR("Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
>  MODULE_DESCRIPTION("ANATOP Regulator driver");
>  MODULE_LICENSE("GPL v2");
> -- 
> 1.7.10.4
> 
> 

