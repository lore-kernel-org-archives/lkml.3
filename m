Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaAPFsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:48:05 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:43706
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbaAPFsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:48:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <LeoLi@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH 0/7] DMA: Freescale: driver cleanups and enhancements
Date: Thu, 16 Jan 2014 13:47:19 +0800
Message-ID: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Hi Vinod Koul and Dan Williams,
Please have a look at these patches.

Note that patch 2~6 had beed sent out for upstream before, but were together
with other storage patches at that time, that was not easy for being reviewed
and merged, so I send them separately this time.

Thanks.

Hongbo Zhang (7):
  DMA: Freescale: unify register access methods
  DMA: Freescale: remove attribute DMA_INTERRUPT of dmaengine
  DMA: Freescale: add fsl_dma_free_descriptor() to reduce code
    duplication
  DMA: Freescale: move functions to avoid forward declarations
  DMA: Freescale: change descriptor release process for supporting
    async_tx
  DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
  DMA: Freescale: add suspend resume functions for DMA driver

 drivers/dma/fsldma.c |  592 ++++++++++++++++++++++++++++++++------------------
 drivers/dma/fsldma.h |   33 ++-
 2 files changed, 412 insertions(+), 213 deletions(-)

-- 
1.7.9.5



