Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3EUSdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:33:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1754 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab3EUSdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:33:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,715,1363158000"; 
   d="scan'208";a="49274477"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: msm: Remove unused and unmapped MSM_TLMM_BASE for 8x60
Date: Tue, 21 May 2013 11:32:42 -0700
Message-Id: <1369161163-6448-3-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1369161163-6448-1-git-send-email-rvaswani@codeaurora.org>
References: <1369161163-6448-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSM_TLMM_BASE is currently not mapped by 8x60. Remove it.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 199372e..cf24b5c 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -41,10 +41,6 @@
 #define MSM8X60_QGIC_CPU_PHYS	0x02081000
 #define MSM8X60_QGIC_CPU_SIZE	SZ_4K
 
-#define MSM_TLMM_BASE		IOMEM(0xF0004000)
-#define MSM_TLMM_PHYS		0x00800000
-#define MSM_TLMM_SIZE		SZ_16K
-
 #define MSM8X60_TMR_PHYS	0x02000000
 #define MSM8X60_TMR_SIZE	SZ_4K
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

