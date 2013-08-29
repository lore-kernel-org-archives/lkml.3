Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3H2Sc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:32:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46253 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab3H2Sc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:32:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,984,1367971200"; 
   d="scan'208";a="48860315"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>
Subject: [PATCH v5 03/13] arm64: define DMA_ERROR_CODE
Date: Thu, 29 Aug 2013 19:32:24 +0100
Message-ID: <1377801154-29215-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: catalin.marinas@arm.com
CC: will.deacon@arm.com
---
 arch/arm64/include/asm/dma-mapping.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 8d18100..c2cb8a0 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -25,6 +25,7 @@
 
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
+#define DMA_ERROR_CODE	(~0)
 extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
-- 
1.7.2.5

