Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaGaKFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:05:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54653 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaGaKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:05:45 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, "byungchul.park" <byungchul.park@lge.com>
Subject: [PATCH 1/1] fix a typing error in fpsimd_save_partial_state ENDPROC
Date: Thu, 31 Jul 2014 19:05:36 +0900
Message-Id: <1406801136-7861-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "byungchul.park" <byungchul.park@lge.com>

commit 190f1ca85d07 (arm64: add support for kernel mode NEON in interrupt context)
introduced a typing error in fpsimd_save_partial_state ENDPROC.
fix the typing error.

Signed-off-by: byungchul.park <byungchul.park@lge.com>
---
 arch/arm64/kernel/entry-fpsimd.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
index d358cca..c44a82f 100644
--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -52,7 +52,7 @@ ENDPROC(fpsimd_load_state)
 ENTRY(fpsimd_save_partial_state)
 	fpsimd_save_partial x0, 1, 8, 9
 	ret
-ENDPROC(fpsimd_load_partial_state)
+ENDPROC(fpsimd_save_partial_state)
 
 /*
  * Load the bottom n FP registers.
-- 
1.7.9.5

