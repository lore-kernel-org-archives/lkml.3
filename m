Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3CDUUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:20:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51823 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab3CDUUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:20:36 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
Date: Mon,  4 Mar 2013 21:20:20 +0100
Message-Id: <1362428421-9244-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1362428421-9244-1-git-send-email-bp@alien8.de>
References: <1362428421-9244-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This should be under the PARAVIRT_GUEST menu.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5b1218..f922a9b9a319 100644
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
 
-- 
1.8.1.3.535.ga923c31

