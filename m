Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbbA0SQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:16:42 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:50823 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbbA0SQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:16:39 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Martin Mares <mj@ucw.cz>, Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/kernel/head_64: fix path in comments
Date: Wed, 28 Jan 2015 00:16:28 +0600
Message-Id: <1422382588-10367-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/kernel/head_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index a468c0a..6975f5d 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/kernel/head.S -- start in 32bit and switch to 64bit
+ *  linux/arch/x86/kernel/head_64.S -- start in 32bit and switch to 64bit
  *
  *  Copyright (C) 2000 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright (C) 2000 Pavel Machek <pavel@suse.cz>
@@ -56,7 +56,7 @@ startup_64:
 	 * %rsi holds a physical pointer to real_mode_data.
 	 *
 	 * We come here either directly from a 64bit bootloader, or from
-	 * arch/x86_64/boot/compressed/head.S.
+	 * arch/x86/boot/compressed/head_64.S.
 	 *
 	 * We only come here initially at boot nothing else comes here.
 	 *
-- 
2.3.0-rc1

