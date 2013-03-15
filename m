Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3COQV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:21:59 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:62943 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab3COQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:21:57 -0400
Message-ID: <1363364515.1335.125.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix comment typo "CONFIG_MISALIGN_ACCESS"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 17:21:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2013 16:21:55.0732 (UTC) FILETIME=[35D70540:01CE2199]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 arch/arc/kernel/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/kernel/disasm.c b/arch/arc/kernel/disasm.c
index 2f39028..d14764a 100644
--- a/arch/arc/kernel/disasm.c
+++ b/arch/arc/kernel/disasm.c
@@ -535,4 +535,4 @@ int __kprobes disasm_next_pc(unsigned long pc, struct pt_regs *regs,
 	return instr.is_branch;
 }
 
-#endif /* CONFIG_KGDB || CONFIG_MISALIGN_ACCESS || CONFIG_KPROBES */
+#endif /* CONFIG_KGDB || CONFIG_ARC_MISALIGN_ACCESS || CONFIG_KPROBES */
-- 
1.7.11.7

