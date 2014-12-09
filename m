Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbaLIKSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:18:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaLIKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:18:49 -0500
Date: Tue, 9 Dec 2014 02:18:33 -0800
From: tip-bot for Richard Weinberger <tipbot@zytor.com>
Message-ID: <tip-15bae280e412e79d74912c7ae6b6a002444edb1f@git.kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, richard@nod.at, hpa@zytor.com,
        torvalds@linux-foundation.org
Reply-To: richard@nod.at, torvalds@linux-foundation.org, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <1416958612-7448-1-git-send-email-richard@nod.at>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/kconfig/defconfig: Enable CONFIG_FHANDLE=y
Git-Commit-ID: 15bae280e412e79d74912c7ae6b6a002444edb1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15bae280e412e79d74912c7ae6b6a002444edb1f
Gitweb:     http://git.kernel.org/tip/15bae280e412e79d74912c7ae6b6a002444edb1f
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Wed, 26 Nov 2014 00:36:52 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Dec 2014 12:04:17 +0100

x86/kconfig/defconfig: Enable CONFIG_FHANDLE=y

systemd has a hard dependency on CONFIG_FHANDLE.
If you run systemd with CONFIG_FHANDLE=n it will somehow
boot but fail to spawn a getty or other basic services.
As systemd is now used by most x86 distributions it
makes sense to enabled this by default and save kernel
hackers a lot of value debugging time.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: gregkh@linuxfoundation.org
Cc: rafael.j.wysocki@intel.com
Cc: pebolle@tiscali.nl
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1416958612-7448-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/configs/i386_defconfig   | 1 +
 arch/x86/configs/x86_64_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 32d2e70..419819d 100644
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
index a481dd4..4c311dd 100644
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
