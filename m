Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaLGU2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:28:17 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57397 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaLGU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:28:15 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jonas Bonn <jonas@southpole.se>, linux@openrisc.net
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: openrisc: kernel: traps.c:  Remove unused function
Date: Sun,  7 Dec 2014 21:30:53 +0100
Message-Id: <1417984253-15964-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function show_trace_task() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/openrisc/kernel/traps.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 3d3f606..cc09827 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -98,13 +98,6 @@ void show_stack(struct task_struct *task, unsigned long *esp)
 	return;
 }
 
-void show_trace_task(struct task_struct *tsk)
-{
-	/*
-	 * TODO: SysRq-T trace dump...
-	 */
-}
-
 void show_registers(struct pt_regs *regs)
 {
 	int i;
-- 
1.7.10.4

