Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbbAEOYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:24:23 -0500
Received: from mail.zhinst.com ([212.126.164.98]:37051 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbbAEOYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:24:22 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arc: Remove unused prepare_to_copy()
Date: Mon,  5 Jan 2015 15:24:18 +0100
Message-Id: <1420467858-16942-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare_to_copy() was removed from all architectures supported at that
time in commit 55ccf3fe3f9a ("fork: move the real prepare_to_copy()
users to arch_dup_task_struct()"). Remove it from arc as well.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/arc/include/asm/processor.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index 210fe97..4e54729 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -56,9 +56,6 @@ unsigned long thread_saved_pc(struct task_struct *t);
 /* Free all resources held by a thread */
 #define release_thread(thread) do { } while (0)
 
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)    do { } while (0)
-
 /*
  * A lot of busy-wait loops in SMP are based off of non-volatile data otherwise
  * get optimised away by gcc
-- 
2.2.1


