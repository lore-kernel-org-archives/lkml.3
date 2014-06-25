Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaFYLJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41101 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756182AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Udo Seidel <udoseidel@gmx.de>
Subject: [PATCH -repost 05/21] kgr: update Kconfig documentation
Date: Wed, 25 Jun 2014 13:06:59 +0200
Message-Id: <1403694435-3180-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on Udo's text which was augmented in this patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Udo Seidel <udoseidel@gmx.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
---
 kernel/Kconfig.kgraft | 3 +++
 samples/Kconfig       | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/kernel/Kconfig.kgraft b/kernel/Kconfig.kgraft
index f38d82c06580..bead93646071 100644
--- a/kernel/Kconfig.kgraft
+++ b/kernel/Kconfig.kgraft
@@ -5,3 +5,6 @@ config KGRAFT
 	bool "kGraft infrastructure"
 	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_KGRAFT
+	help
+	  Select this to enable kGraft online kernel patching. The
+	  runtime price is zero, so it is safe to say Y here.
diff --git a/samples/Kconfig b/samples/Kconfig
index b33a397dfc58..12848d1bd8c5 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -58,6 +58,10 @@ config SAMPLE_KDB
 config SAMPLE_KGRAFT_PATCHER
 	tristate "Build kGraft patcher example -- loadable modules only"
 	depends on KGRAFT && m
+	help
+	  Sample code to replace sys_iopl() and sys_capable() via
+	  kGraft. This is only for presentation purposes. It is safe to
+	  say Y here.
 
 config SAMPLE_RPMSG_CLIENT
 	tristate "Build rpmsg client sample -- loadable modules only"
-- 
2.0.0

