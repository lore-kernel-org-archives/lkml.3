Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3AaKvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:51:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3AaKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:51:12 -0500
Date: Thu, 31 Jan 2013 02:50:10 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-7e010562e01aff929126f671ff9e730e22dbdb1b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1359456492-22156-1-git-send-email-bp@alien8.de>
References: <1359456492-22156-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools: Correct typo in tools Makefile
Git-Commit-ID: 7e010562e01aff929126f671ff9e730e22dbdb1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:50:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e010562e01aff929126f671ff9e730e22dbdb1b
Gitweb:     http://git.kernel.org/tip/7e010562e01aff929126f671ff9e730e22dbdb1b
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 29 Jan 2013 11:48:11 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:35:14 -0300

tools: Correct typo in tools Makefile

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
