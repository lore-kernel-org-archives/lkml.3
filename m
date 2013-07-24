Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3GXGsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:48:03 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39633 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3GXGsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <1374646870-5162-1-git-send-email-hongbo.zhang@freescale.com>
References: <1374646870-5162-1-git-send-email-hongbo.zhang@freescale.com>
Date: Wed, 24 Jul 2013 14:47:59 +0800
X-Google-Sender-Auth: LANZk3xUdQA34-fGtEMTrirRAhQ
Message-ID: <CADRPPNQEpa5AzMTo=h3c=HwWMx-=SbWzO+7sfN_iNS74DLbJJw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] DMA: Freescale: Add support for 8-channel DMA engine
From: Li Yang <leoli@freescale.com>
To: hongbo.zhang@freescale.com
Cc: Vinod Koul <vinod.koul@intel.com>, djbw@fb.com,
        Scott Wood <scottwood@freescale.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        devicetree@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 2:21 PM,  <hongbo.zhang@freescale.com> wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>
> Hi Vinod, Dan, Scott and Leo, please have a look at these V2 patches.

Looks fine after the rounds of review.

Acked-by: Li Yang <leoli@freescale.com>

PS: The original email was in html and rejected by lists thanks to the
new gmail composer.  Sorry if you received duplicated emails.

- Leo

>
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch set
> adds support this DMA engine.
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
> - removed the codes handling the register dgsr1, since it isn't used corrently
> - renamed the DMA DT compatible to "fsl,elo3-dma"
> - renamed the new dts files to "elo3-dma-<n>.dtsi"
>
> Hongbo Zhang (4):
>   DMA: Freescale: revise device tree binding document
>   DMA: Freescale: Add new 8-channel DMA engine device tree nodes
>   DMA: Freescale: update driver to support 8-channel DMA engine
>   DMA: Freescale: eliminate a compiling warning
>
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |  118 +++++++++++++++-----
>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81 ++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81 ++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  drivers/dma/Kconfig                                |    9 +-
>  drivers/dma/fsldma.c                               |   11 +-
>  drivers/dma/fsldma.h                               |    2 +-
>  8 files changed, 269 insertions(+), 41 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>
> --
> 1.7.9.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
