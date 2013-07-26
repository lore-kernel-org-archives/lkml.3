Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3GZWDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:03:17 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:37528
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab3GZWDO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:03:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Fri, 26 Jul 2013 17:03:01 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v6 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1374834436-7149-1-git-send-email-hongbo.zhang@freescale.com>
	<1374834436-7149-3-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1374834436-7149-3-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Fri Jul 26 05:27:15 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374876181.30721.28@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 05:27:15 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this  
> patch adds
> the device tree nodes for them.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |   66  
> ++++++++++++++++
>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81  
> ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81  
> ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  5 files changed, 232 insertions(+), 4 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt  
> b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> index ed703d9..c9f81b9 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> @@ -130,6 +130,72 @@ Example:
>  		};
>  	};
> 
> +** Freescale Elo3 DMA Controller
> +   This is EloPlus controller with 8 channels, used in Freescale  
> Txxx and Bxxx
> +   series chips, such as t1040, t4240, b4860.
> +
> +Required properties:
> +
> +- compatible        : must include "fsl,elo3-dma"

OK, you fixed it here, but you still have the "fsl,CHIP-dma" language  
in the rest of the document.  There is no difference between elo3 and  
previous chips regarding fsl,CHIP-dma as far as the binding is  
concerned.

-Scott
