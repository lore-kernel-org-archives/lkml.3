Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaFROEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:04:47 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52824 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbaFROEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:04:46 -0400
Message-ID: <1403100284.1984.115.camel@x220>
Subject: [PATCH v2] [TRIVIAL] ARM: msm: Remove MSM_SCM
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 16:04:44 +0200
In-Reply-To: <20140407215744.GI9985@codeaurora.org>
References: <1396778225.30640.12.camel@x220>
	 <20140407215744.GI9985@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 14:04:45.0287 (UTC) FILETIME=[4221C770:01CF8AFE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
multiplatform") removed all users of Kconfig symbol MSM_SCM. Remove that
symbol too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
v2: added Reviewed-by tag and sent to trivial. See
https://lkml.org/lkml/2014/4/6/19 for v1.

 arch/arm/mach-msm/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 9b26976fb084..a6b50e62a495 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -106,7 +106,4 @@ config MSM_GPIOMUX
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
 
-config MSM_SCM
-	bool
-
 endif
-- 
1.9.3

