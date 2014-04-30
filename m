Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbaD3Oej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:34:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52332 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759209AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: [RFC 05/16] kgr: update Kconfig documentation
Date: Wed, 30 Apr 2014 16:30:38 +0200
Message-Id: <1398868249-26169-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on Udo's text which were augmented in this patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Udo Seidel <udoseidel@gmx.de>
Cc: Vojtech Pavlik <vojtech@suse.cz>
---
 kernel/Kconfig.kgr | 3 +++
 samples/Kconfig    | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/kernel/Kconfig.kgr b/kernel/Kconfig.kgr
index af9125f27b6d..f66fa2c20656 100644
--- a/kernel/Kconfig.kgr
+++ b/kernel/Kconfig.kgr
@@ -5,3 +5,6 @@ config KGR
 	tristate "Kgr infrastructure"
 	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_KGR
+	help
+	 Select this to enable kGraft online kernel patching. The
+	 runtime price is zero, so it is safe to say Y here.
diff --git a/samples/Kconfig b/samples/Kconfig
index a923510443de..29eba4b77812 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -58,6 +58,10 @@ config SAMPLE_KDB
 config SAMPLE_KGR_PATCHER
 	tristate "Build kgr patcher example -- loadable modules only"
 	depends on KGR && m
+	help
+	 Sample code to replace sys_iopl() and sys_capable() via
+	 kGraft. This is only for presentation purposes. It is safe to
+	 say Y here.
 
 config SAMPLE_RPMSG_CLIENT
 	tristate "Build rpmsg client sample -- loadable modules only"
-- 
1.9.2

