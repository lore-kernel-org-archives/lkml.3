Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3AXUFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:05:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3AXUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:05:26 -0500
Date: Thu, 24 Jan 2013 12:05:08 -0800
From: tip-bot for Kees Cook <keescook@chromium.org>
Message-ID: <tip-2c922cd07a0ada4d68e22453c972a5d77be8f20d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        mingo@kernel.org, keescook@chromium.org, fenghua.yu@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20130122210119.GA311@www.outflux.net>
References: <20130122210119.GA311@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cpu/hotplug:
  Remove CONFIG_EXPERIMENTAL dependency
Git-Commit-ID: 2c922cd07a0ada4d68e22453c972a5d77be8f20d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:05:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c922cd07a0ada4d68e22453c972a5d77be8f20d
Gitweb:     http://git.kernel.org/tip/2c922cd07a0ada4d68e22453c972a5d77be8f20d
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 22 Jan 2013 13:01:19 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 11:16:30 +0100

x86/cpu/hotplug: Remove CONFIG_EXPERIMENTAL dependency

The CONFIG_EXPERIMENTAL config item has not carried much meaning
for a while now and is almost always enabled by default. As
agreed during the Linux kernel summit, remove it from any
"depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/20130122210119.GA311@www.outflux.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..2d62103 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1699,7 +1699,7 @@ config HOTPLUG_CPU
 config BOOTPARAM_HOTPLUG_CPU0
 	bool "Set default setting of cpu0_hotpluggable"
 	default n
-	depends on HOTPLUG_CPU && EXPERIMENTAL
+	depends on HOTPLUG_CPU
 	---help---
 	  Set whether default state of cpu0_hotpluggable is on or off.
 
@@ -1728,7 +1728,7 @@ config BOOTPARAM_HOTPLUG_CPU0
 config DEBUG_HOTPLUG_CPU0
 	def_bool n
 	prompt "Debug CPU0 hotplug"
-	depends on HOTPLUG_CPU && EXPERIMENTAL
+	depends on HOTPLUG_CPU
 	---help---
 	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
 	  soon as possible and boots up userspace with CPU0 offlined. User
