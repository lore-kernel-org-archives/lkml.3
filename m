Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaHHHut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:50:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42069 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHHHuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:50:46 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH linux-next] doc: fix /sys/kernel/debug/.../tlb_single_page location
Date: Fri,  8 Aug 2014 00:49:55 -0700
Message-Id: <1407484195-1441-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the documented sys location of tlb_single_page_flush_ceiling
which is under /sys/kernel/debug/... not /sys/debug/kernel/...

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
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
-- 
2.1.0.rc1

