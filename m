Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab3DOHGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:06:39 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:17054
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932679Ab3DOHGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:06:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLABQS-02-8KW-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/2 V2] iommu/amd: Changing interrupt handling scheme and HW bug workaround
Date: Mon, 15 Apr 2013 02:06:53 -0500
Message-ID: <1366009613-44549-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

This patch set contains two patches which affect IOMMU interrupt handling.
Patch 1 Implements the workaround for hardware issue when handling interrupts
and independent of patch 2.  Patch 2 Modify interrupt handling thread to only 
handle IOMMU interrupt on per-thread basis. It also depends on patch 1.

Please see individual patch for more information.

Suravee Suthikulpanit (2):
  iommu/amd: Add workaround for ERBT1312
  iommu/AMD: Per-thread IOMMU Interrupt Handling

 drivers/iommu/amd_iommu.c      |   59 ++++++++++++++++++++--------------------
 drivers/iommu/amd_iommu_init.c |    2 +-
 2 files changed, 31 insertions(+), 30 deletions(-)

-- 
1.7.10.4


