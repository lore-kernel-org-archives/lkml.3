Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaGSFKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:10:11 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:59638 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaGSFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:10:10 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: ralf@linux-mips.org
Cc: paul.burton@imgtec.com, Leonid.Yegoshin@imgtec.com,
        markos.chandras@imgtec.com, Steven.Hill@imgtec.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mips: Remove uneeded line in cmp_smp_finish
Date: Sat, 19 Jul 2014 01:10:04 -0400
Message-Id: <1405746604-7737-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a unneeded line from this file as stated by the
fix me in this file.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/mips/kernel/smp-cmp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index fc8a515..61bfa20 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -60,8 +60,6 @@ static void cmp_smp_finish(void)
 {
 	pr_debug("SMPCMP: CPU%d: %s\n", smp_processor_id(), __func__);
 
-	/* CDFIXME: remove this? */
-	write_c0_compare(read_c0_count() + (8 * mips_hpt_frequency / HZ));
 
 #ifdef CONFIG_MIPS_MT_FPAFF
 	/* If we have an FPU, enroll ourselves in the FPU-full mask */
-- 
1.9.1

