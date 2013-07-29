Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3G2LiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:38:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:35292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3G2LiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,768,1367996400"; 
   d="scan'208";a="372850340"
Date: Mon, 29 Jul 2013 16:29:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: djbw@fb.com, leoli@freescale.com, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] DMA: Freescale: Add support for 8-channel DMA
 engine
Message-ID: <20130729105901.GI29095@intel.com>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 06:49:01PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Hi Vinod, Dan, Scott and Leo, please have a look at these V7 patches.
The dma relates changes look okay to me.

I need someone to review and ACK the DT bindings.

~Vinod
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch set
> adds support this DMA engine.
> 
> V6->V7 changes:
> - only remove unnecessary "CHIP-dma" explanations in [1/3]
> 
> V5->V6 changes:
> - minor updates of descriptions in binding document and Kconfig
> - remove [4/4], that should be another patch in future
> 
> V4->V5 changes:
> - update description in the dt binding document, to make it more resonable
> - add new patch [4/4] to eliminate a compiling warning which already exists
>   for a long time
> 
> V3->V4 changes:
> - introduce new patch [1/3] to revise the legacy dma binding document
> - and then add new paragraph to describe new dt node binding in [2/3]
> - rebase to latest kernel v3.11-rc1
> 
> V2->V3 changes:
> - edit Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> - edit text string in Kconfig and the driver files, using "elo series" to
>   mention all the current "elo*"
> 
> V1->V2 changes:
> - removed the codes handling the register dgsr1, since it isn't used currently
> - renamed the DMA DT compatible to "fsl,elo3-dma"
> - renamed the new dts files to "elo3-dma-<n>.dtsi"
> 
> Hongbo Zhang (3):
>   DMA: Freescale: revise device tree binding document
>   DMA: Freescale: Add new 8-channel DMA engine device tree nodes
>   DMA: Freescale: update driver to support 8-channel DMA engine
> 
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |  114 +++++++++++++++-----
>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81 ++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81 ++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  drivers/dma/Kconfig                                |    9 +-
>  drivers/dma/fsldma.c                               |    9 +-
>  drivers/dma/fsldma.h                               |    2 +-
>  8 files changed, 264 insertions(+), 40 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> 
> -- 
> 1.7.9.5
> 
> 
> 

-- 
