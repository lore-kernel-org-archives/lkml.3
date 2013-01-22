Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3AVTVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:21:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab3AVTVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:21:31 -0500
Date: Tue, 22 Jan 2013 14:21:03 -0500
From: Kyle McMartin <kyle@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com
Subject: [PATCH] CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL
Message-ID: <20130122192102.GE6538@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EXPERT is a bit silly a place for this, and hides it
unnecessarily. CONFIG_DEBUG_KERNEL makes much more sense.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -243,7 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
 config PANIC_ON_OOPS
-	bool "Panic on Oops" if EXPERT
+	bool "Panic on Oops" if DEBUG_KERNEL
 	default n
 	help
 	  Say Y here to enable the kernel to panic when it oopses. This
