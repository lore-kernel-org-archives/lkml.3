Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935252Ab3E2Vp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:45:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56508 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935203Ab3E2Vps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:45:48 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] msm: Remove unused file core.h
Date: Wed, 29 May 2013 14:37:28 -0700
Message-Id: <1369863449-25059-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit be2109e13fc6f017040c57615acfe1065723687b removed the usage
of core.h. Remove the file as well.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/core.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 arch/arm/mach-msm/core.h

diff --git a/arch/arm/mach-msm/core.h b/arch/arm/mach-msm/core.h
deleted file mode 100644
index a9bab53..0000000
--- a/arch/arm/mach-msm/core.h
+++ /dev/null
@@ -1,2 +0,0 @@
-extern struct smp_operations msm_smp_ops;
-extern void msm_cpu_die(unsigned int cpu);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

