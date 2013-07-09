Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3GIQtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:49:00 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:16837
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab3GIQs7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:48:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Tue, 9 Jul 2013 11:48:46 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH V2 1/2] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <vakul@freescale.com>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com>
	<1373005626-20726-2-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1373005626-20726-2-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Fri Jul  5 01:27:05 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1373388526.8183.191@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:27:05 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this  
> patch add
> the device tree nodes for them.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi   |   90  
> +++++++++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi   |   90  
> +++++++++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi |    4 +-
>  3 files changed, 182 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi

Please update Documentation/devicetree/bindings/powerpc/fsl/dma.txt for  
the new compatible and dgsr1.

-Scott
