Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3A3OrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:47:15 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54389
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab3A3OrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:12 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/21] tools: Correct typo in tools Makefile
Date: Wed, 30 Jan 2013 11:46:51 -0300
Message-Id: <1359557222-17547-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It should be

make -C tools/ <tool>_install

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1359456492-22156-1-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/Makefile b/tools/Makefile
index 1f9a529..798fa0e 100644
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
1.8.1.1.361.gec3ae6e

