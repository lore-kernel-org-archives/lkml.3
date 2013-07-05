Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3GEG2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:28:25 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:20378
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab3GEG2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:28:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <vakul@freescale.com>, Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH V2 0/2] DMA: Freescale: Add support for 8-channel DMA engine
Date: Fri, 5 Jul 2013 14:27:04 +0800
Message-ID: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Hi Vinod, Dan, Leo and Scott, please have a look at these V2 patches.

Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch set
adds support this DMA engine.

V1->v2 changes:
- removed the codes handling the register dgsr1, since it isn't used corrently
- renamed the DMA DT compatible to "fsl,elo3-dma"
- renamed the new dts files to "elo3-dma-<n>.dtsi"


Hongbo Zhang (2):
  DMA: Freescale: Add new 8-channel DMA engine device tree nodes
  DMA: Freescale: update driver to support 8-channel DMA engine

 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi   |   90 +++++++++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi   |   90 +++++++++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi |    4 +-
 drivers/dma/fsldma.c                        |    5 +-
 drivers/dma/fsldma.h                        |    2 +-
 5 files changed, 187 insertions(+), 4 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi

-- 
1.7.9.5



