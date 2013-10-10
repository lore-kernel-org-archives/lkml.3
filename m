Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3JJQhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:37:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:20514 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab3JJQhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:37:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1073,1371106800"; 
   d="scan'208";a="414977350"
Date: Thu, 10 Oct 2013 21:14:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lu Jingchang-B35083 <B35083@freescale.com>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20131010154414.GY2954@intel.com>
References: <1379498279-16096-1-git-send-email-b35083@freescale.com>
 <B56CDBE15CE27145A4B77D2D24263E8522EFE6@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E8522EFE6@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:39:04AM +0000, Lu Jingchang-B35083 wrote:
> Hi, Vinod,
> 
>   Could you please help review this patch? Could it be merged into your next tree?
>   Thanks!
Where is the patch 1 & 2 of the series, I dont sem to find it.
Also I need ACK from one of the DT maintainers on the binding before I can carry
this

--
~Vinod
> 
> 
> Best Regards,
> Jingchang
> 
> 
> > -----Original Message-----
> > From: Lu Jingchang-B35083
> > Sent: Wednesday, September 18, 2013 5:58 PM
> > To: vinod.koul@intel.com
> > Cc: shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; devicetree@vger.kernel.org; Lu Jingchang-
> > B35083; Wang Huan-B18965
> > Subject: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
> > 
> > Add Freescale enhanced direct memory(eDMA) controller support.
> > The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> > to eDMA channels.
> > This module can be found on Vybrid and LS-1 SoCs.
> > 
> > Signed-off-by: Alison Wang <b18965@freescale.com>
> > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> > ---
> > changes in v6:
> >   holding lock in dma_control to prevent race.
> > 
> > changes in v5:
> >   config slave_id when dmaengine_slave_config intead of channel request.
> >   adding residue calculation and dma pause/resume device control.
> > 
> > changes in v4:
> >   using exact compatible string in binding document.
> > 
> > changes in v3:
> >   handle all pending interrupt one time.
> >   add protect lock on dma transfer complete handling.
> >   change desc and tcd alloc flag to GFP_NOWAIT.
> >   add sanity check and error messages.
> > 
> > changes in v2:
> >   using generic dma-channels property instead of fsl,dma-channel.
> >   rename the binding document to fsl-edma.txt.
> > 
> > 
> >  Documentation/devicetree/bindings/dma/fsl-edma.txt |  84 ++
> >  drivers/dma/Kconfig                                |  10 +
> >  drivers/dma/Makefile                               |   1 +
> >  drivers/dma/fsl-edma.c                             | 944
> > +++++++++++++++++++++
> >  4 files changed, 1039 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
> >  create mode 100644 drivers/dma/fsl-edma.c
> 

-- 
