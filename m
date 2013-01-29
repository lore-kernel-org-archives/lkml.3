Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3A2KsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:48:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40725 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3A2KsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:48:15 -0500
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/2] tools: Correct typo in tools Makefile
Date: Tue, 29 Jan 2013 11:48:11 +0100
Message-Id: <1359456492-22156-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It should be

make -C tools/ <tool>_install

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/Makefile b/tools/Makefile
index 1f9a529fe544..798fa0ef048e 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -15,7 +15,7 @@ help:
 	@echo '  x86_energy_perf_policy - Intel energy policy tool'
 	@echo ''
 	@echo 'You can do:'
-	@echo ' $$ make -C tools/<tool>_install'
+	@echo ' $$ make -C tools/ <tool>_install'
 	@echo ''
 	@echo '  from the kernel command line to build and install one of'
 	@echo '  the tools above'
-- 
1.8.1.rc3

