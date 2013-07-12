Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab3GLN3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:29:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab3GLN3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:29:12 -0400
Date: Fri, 12 Jul 2013 06:28:59 -0700
From: tip-bot for Xiong Zhou <tipbot@zytor.com>
Message-ID: <tip-ff5599816711d2e67da2d7561fd36ac48debd433@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jencce.kernel@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jencce.kernel@gmail.com, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1307091053280.28371@M2420>
References: <alpine.DEB.2.02.1307091053280.28371@M2420>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/platform/ce4100:
  Add header file for reboot type
Git-Commit-ID: ff5599816711d2e67da2d7561fd36ac48debd433
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:29:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff5599816711d2e67da2d7561fd36ac48debd433
Gitweb:     http://git.kernel.org/tip/ff5599816711d2e67da2d7561fd36ac48debd433
Author:     Xiong Zhou <jencce.kernel@gmail.com>
AuthorDate: Tue, 9 Jul 2013 11:06:27 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 12:21:20 +0200

x86/platform/ce4100: Add header file for reboot type

Add header file for reboot type to fix this build failure:

 error: 'reboot_type' undeclared (first use in this function)
 error: 'BOOT_KBD' undeclared (first use in this function)

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
Cc: rui.zhang@intel.com
Cc: alan@linux.intel.com
Cc: ffainelli@freebox.fr
Cc: mbizon@freebox.fr
Cc: matthew.garrett@nebula.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1307091053280.28371@M2420
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/ce4100/ce4100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index f8ab494..9962015 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
+#include <linux/reboot.h>
 
 #include <asm/ce4100.h>
 #include <asm/prom.h>
