Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3JLUpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:45:47 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10027
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096Ab3JLUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:45:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2izz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <alex.williamson@redhat.com>, <r65777@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 0/3] iommu/fsl: PAMU driver fixes.
Date: Sun, 13 Oct 2013 02:02:31 +0530
Message-ID: <1381609954-15283-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes a build failure, when we try to build for a Freescale
platform without PCI support.

The second patch enables a default DMA window for the device, once it's
detached from a domain. In case of vfio, once device is detached from a
guest it can be again used by the host.

The last patch adds the maintainer entry for the Freescale PAMU driver.

Varun Sethi (3):
  iommu/fsl: Factor out PCI specific code.
  iommu/fsl: Enable default DMA window for PCIe devices once detached
  Add maintainers entry for the Freescale PAMU driver.

 MAINTAINERS                     |    7 +++
 drivers/iommu/fsl_pamu.c        |   43 ++++++++++++---
 drivers/iommu/fsl_pamu.h        |    1 +
 drivers/iommu/fsl_pamu_domain.c |  116 +++++++++++++++++++++++++--------------
 4 files changed, 117 insertions(+), 50 deletions(-)

-- 
1.7.9.5


