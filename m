Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbbAFDef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:34:35 -0500
Received: from smtprelay05.ispgateway.de ([80.67.18.28]:50489 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbAFDee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:34:34 -0500
From: Christoph Jaeger <cj@linux.com>
To: jpoimboe@redhat.com, sjenning@redhat.com, jkosina@suse.cz, vojtech@suse.cz
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <cj@linux.com>
Subject: [PATCH linux-next] livepatch: kconfig: use bool instead of boolean
Date: Mon,  5 Jan 2015 22:34:09 -0500
Message-Id: <1420515249-4848-1-git-send-email-cj@linux.com>
X-Mailer: git-send-email 2.1.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keyword 'boolean' for type definition attributes is considered deprecated and
should not be used anymore. No functional changes.

Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
Reference: http://lkml.kernel.org/r/1419108071-11607-1-git-send-email-cj@linux.com
Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 kernel/livepatch/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 96da00f..66797aa 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -1,10 +1,10 @@
 config ARCH_HAVE_LIVE_PATCHING
-	boolean
+	bool
 	help
 	  Arch supports kernel live patching
 
 config LIVE_PATCHING
-	boolean "Kernel Live Patching"
+	bool "Kernel Live Patching"
 	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on MODULES
 	depends on SYSFS
-- 
2.1.0

