Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab3I0EWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:22:09 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61048 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3I0EVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:21:45 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] um/vdso: add .gitignore for a couple of targets
Date: Fri, 27 Sep 2013 09:44:47 +0530
Message-Id: <1380255287-5818-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.299.gb3e7d24.dirty
In-Reply-To: <1380255287-5818-1-git-send-email-artagnon@gmail.com>
References: <1380255287-5818-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/x86/um/vdso/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 arch/x86/um/vdso/.gitignore

diff --git a/arch/x86/um/vdso/.gitignore b/arch/x86/um/vdso/.gitignore
new file mode 100644
index 0000000..9cac6d0
--- /dev/null
+++ b/arch/x86/um/vdso/.gitignore
@@ -0,0 +1,2 @@
+vdso-syms.lds
+vdso.lds
-- 
1.8.4.299.gb3e7d24.dirty

