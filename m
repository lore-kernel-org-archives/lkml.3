Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3DNQKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:10:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3DNQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:10:40 -0400
Date: Sun, 14 Apr 2013 09:10:15 -0700
From: tip-bot for Paul Bolle <tipbot@zytor.com>
Message-ID: <tip-a7e6567585e513cb4e44387831cb75eb5b562cbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1365698982.1427.3.camel@x61.thuisdomein>
References: <1365698982.1427.3.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm/fixmap: Remove unused FIX_CYCLONE_TIMER
Git-Commit-ID: a7e6567585e513cb4e44387831cb75eb5b562cbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 14 Apr 2013 09:10:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7e6567585e513cb4e44387831cb75eb5b562cbb
Gitweb:     http://git.kernel.org/tip/a7e6567585e513cb4e44387831cb75eb5b562cbb
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Thu, 11 Apr 2013 18:49:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Apr 2013 07:21:18 +0200

x86/mm/fixmap: Remove unused FIX_CYCLONE_TIMER

The last users of FIX_CYCLONE_TIMER were removed in v2.6.18. We
can remove this unneeded constant.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Link: http://lkml.kernel.org/r/1365698982.1427.3.camel@x61.thuisdomein
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/fixmap.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index a09c285..83ea2fb 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -107,9 +107,6 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_F00F_BUG
 	FIX_F00F_IDT,	/* Virtual mapping for IDT */
 #endif
-#ifdef CONFIG_X86_CYCLONE_TIMER
-	FIX_CYCLONE_TIMER, /*cyclone timer register*/
-#endif
 #ifdef CONFIG_X86_32
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
