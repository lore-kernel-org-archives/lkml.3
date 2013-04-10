Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936571Ab3DJNwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:52:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935117Ab3DJNw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:52:29 -0400
Date: Wed, 10 Apr 2013 06:52:06 -0700
From: tip-bot for Paul Bolle <tipbot@zytor.com>
Message-ID: <tip-781b0e870c72be8a24c074073547e74e7b9bffd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, lethal@linux-sh.org, tglx@linutronix.de,
        len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, lethal@linux-sh.org,
        len.brown@intel.com
In-Reply-To: <1363869683.1390.134.camel@x61.thuisdomein>
References: <1363869683.1390.134.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] idle: Remove unused ARCH_HAS_DEFAULT_IDLE
Git-Commit-ID: 781b0e870c72be8a24c074073547e74e7b9bffd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:52:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  781b0e870c72be8a24c074073547e74e7b9bffd6
Gitweb:     http://git.kernel.org/tip/781b0e870c72be8a24c074073547e74e7b9bffd6
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Thu, 21 Mar 2013 13:41:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 14:40:46 +0200

idle: Remove unused ARCH_HAS_DEFAULT_IDLE

The Kconfig symbol ARCH_HAS_DEFAULT_IDLE is unused. Commit
a0bfa1373859e9d11dc92561a8667588803e42d8 ("cpuidle: stop
depending on pm_idle") removed the only place were it was
actually used. But it did not remove its Kconfig entries (for sh
and x86). Remove those two entries now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Len Brown <len.brown@intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/1363869683.1390.134.camel@x61.thuisdomein
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sh/Kconfig  | 3 ---
 arch/x86/Kconfig | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 853cbc9..0917fc3 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -150,9 +150,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_HAS_DEFAULT_IDLE
-	def_bool y
-
 config NO_IOPORT
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN && \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 422a72b..734152d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -189,9 +189,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_DEFAULT_IDLE
-	def_bool y
-
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
