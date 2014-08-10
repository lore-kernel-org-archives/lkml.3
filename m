Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaHJHr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:47:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:47:55 -0400
Date: Sun, 10 Aug 2014 00:46:37 -0700
From: tip-bot for Jeremiah Mahler <tipbot@zytor.com>
Message-ID: <tip-129ea00594bf993251a5c70d14cbe16f3624e505@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rdunlap@infradead.org, jmmahler@gmail.com, dave.hansen@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmmahler@gmail.com, rdunlap@infradead.org, tglx@linutronix.de,
        dave.hansen@linux.intel.com
In-Reply-To: <1407484195-1441-1-git-send-email-jmmahler@gmail.com>
References: <1407484195-1441-1-git-send-email-jmmahler@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/doc: Fix the 'tlb_single_page_flush_ceiling'
  sysconfig path
Git-Commit-ID: 129ea00594bf993251a5c70d14cbe16f3624e505
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  129ea00594bf993251a5c70d14cbe16f3624e505
Gitweb:     http://git.kernel.org/tip/129ea00594bf993251a5c70d14cbe16f3624e505
Author:     Jeremiah Mahler <jmmahler@gmail.com>
AuthorDate: Fri, 8 Aug 2014 00:49:55 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 10 Aug 2014 09:09:26 +0200

x86/doc: Fix the 'tlb_single_page_flush_ceiling' sysconfig path

Fix the documented sysconfig location of 'tlb_single_page_flush_ceiling'
which is under /sys/kernel/debug/... not /sys/debug/kernel/...

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Link: http://lkml.kernel.org/r/1407484195-1441-1-git-send-email-jmmahler@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/x86/tlb.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/x86/tlb.txt b/Documentation/x86/tlb.txt
index 2b3a82e..39d1723 100644
--- a/Documentation/x86/tlb.txt
+++ b/Documentation/x86/tlb.txt
@@ -35,7 +35,7 @@ invlpg instruction (or instructions _near_ it) show up high in
 profiles.  If you believe that individual invalidations being
 called too often, you can lower the tunable:
 
-	/sys/debug/kernel/x86/tlb_single_page_flush_ceiling
+	/sys/kernel/debug/x86/tlb_single_page_flush_ceiling
 
 This will cause us to do the global flush for more cases.
 Lowering it to 0 will disable the use of the individual flushes.
