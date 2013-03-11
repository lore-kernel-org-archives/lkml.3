Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3CKTXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:23:12 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46948 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3CKTXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:23:10 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] Arch: x86: kernel: smpboot.c: Remove unused variable
Date: Mon, 11 Mar 2013 21:23:00 +0200
Message-Id: <1363029780-2902-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'c'

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 arch/x86/kernel/smpboot.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a6ceaed..7bc998a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1367,7 +1367,6 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-- 
1.7.10.4

