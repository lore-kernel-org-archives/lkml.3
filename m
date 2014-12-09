Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaLINGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:06:40 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39975 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaLINGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:06:39 -0500
Date: Tue, 9 Dec 2014 14:06:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug tree change for v3.19
Message-ID: <20141209130634.GA30749@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   # HEAD: 15bae280e412e79d74912c7ae6b6a002444edb1f x86/kconfig/defconfig: Enable CONFIG_FHANDLE=y

A defconfig update.

 Thanks,

	Ingo

------------------>
Richard Weinberger (1):
      x86/kconfig/defconfig: Enable CONFIG_FHANDLE=y


 arch/x86/configs/i386_defconfig   | 1 +
 arch/x86/configs/x86_64_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 32d2e7056c87..419819d6dab3 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -8,6 +8,7 @@ CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
+CONFIG_FHANDLE=y
 CONFIG_AUDIT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index a481dd4755d5..4c311ddd973b 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -7,6 +7,7 @@ CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
+CONFIG_FHANDLE=y
 CONFIG_AUDIT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
