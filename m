Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaDFJ5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:57:10 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:56206 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbaDFJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:57:08 -0400
Message-ID: <1396778225.30640.12.camel@x220>
Subject: [PATCH] ARM: msm: Remove MSM_SCM
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 11:57:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2014 09:57:06.0483 (UTC) FILETIME=[91707830:01CF517E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
multiplatform") removed all users of Kconfig symbol MSM_SCM. Remove that
symbol too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only by grepping the tree.

 arch/arm/mach-msm/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index a7f959e58c3d..be8413abfa4f 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -109,7 +109,4 @@ config MSM_GPIOMUX
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
 
-config MSM_SCM
-	bool
-
 endif
-- 
1.9.0

