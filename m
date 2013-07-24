Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3GXTaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:30:15 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:35603
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364Ab3GXTaN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:30:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 24 Jul 2013 14:30:07 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v5 3/4] DMA: Freescale: update driver to support
 8-channel DMA engine
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1374646870-5162-1-git-send-email-hongbo.zhang@freescale.com>
	<1374646870-5162-4-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1374646870-5162-4-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Wed Jul 24 01:21:08 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374694207.15592.62@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 01:21:08 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> This patch adds support to 8-channel DMA engine, thus the driver  
> works for both
> the new 8-channel and the legacy 4-channel DMA engines.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  drivers/dma/Kconfig  |    9 +++++----
>  drivers/dma/fsldma.c |    9 ++++++---
>  drivers/dma/fsldma.h |    2 +-
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 6825957..1b78272 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -89,14 +89,15 @@ config AT_HDMAC
>  	  Support the Atmel AHB DMA controller.
> 
>  config FSL_DMA
> -	tristate "Freescale Elo and Elo Plus DMA support"
> +	tristate "Freescale Elo series DMA support"
>  	depends on FSL_SOC
>  	select DMA_ENGINE
>  	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
>  	---help---
> -	  Enable support for the Freescale Elo and Elo Plus DMA  
> controllers.
> -	  The Elo is the DMA controller on some 82xx and 83xx parts,  
> and the
> -	  Elo Plus is the DMA controller on 85xx and 86xx parts.
> +	  Enable support for the Freescale Elo series DMA controllers.
> +	  The Elo is the DMA controller on some mpc82xx and mpc83xx  
> parts, the
> +	  EloPlus is on mpc85xx and mpc86xx and Pxxx parts, and the  
> Elo3 is on
> +	  some Txxx and Bxxx parts. Look up user manuals for details  
> anyway.

The user manuals do not use the "elo" terminology.  I also don't  
understand the tone you're trying to convey with "anyway".

-Scott
