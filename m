Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBIStt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:49:49 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62426 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaBISso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:44 -0500
From: Richard Weinberger <richard@nod.at>
To: Vineet Gupta <vgupta@synopsys.com>,
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
Date: Sun,  9 Feb 2014 19:48:05 +0100
Message-Id: <1391971686-9517-28-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arc/plat-arcfpga/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 295cefe..33058aa 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -33,7 +33,6 @@ config ISS_SMP_EXTN
 	bool "ARC SMP Extensions (ISS Models only)"
 	default n
 	depends on SMP
-	select ARC_HAS_COH_RTSC
 	help
 	  SMP Extensions to ARC700, in a "simulation only" Model, supported in
 	  ARC ISS (Instruction Set Simulator).
-- 
1.8.4.2

