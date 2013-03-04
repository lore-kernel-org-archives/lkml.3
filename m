Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab3CDX4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:56:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3CDX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:56:51 -0500
Date: Mon, 4 Mar 2013 15:54:42 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-2c59cad6941cb55990fa6e19d84ae027c46991ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1362428421-9244-2-git-send-email-bp@alien8.de>
References: <1362428421-9244-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86, Kconfig:
  Move PARAVIRT_DEBUG into the paravirt menu
Git-Commit-ID: 2c59cad6941cb55990fa6e19d84ae027c46991ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Mar 2013 15:54:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c59cad6941cb55990fa6e19d84ae027c46991ee
Gitweb:     http://git.kernel.org/tip/2c59cad6941cb55990fa6e19d84ae027c46991ee
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Mar 2013 21:20:20 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 4 Mar 2013 13:14:06 -0800

x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu

This should be under the PARAVIRT_GUEST menu.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1362428421-9244-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..f922a9b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -659,8 +659,6 @@ config PARAVIRT_SPINLOCKS
 config PARAVIRT_CLOCK
 	bool
 
-endif
-
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
 	depends on PARAVIRT && DEBUG_KERNEL
@@ -668,6 +666,8 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+endif #PARAVIRT_GUEST
+
 config NO_BOOTMEM
 	def_bool y
 
