Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbbAESh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:37:26 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:65203 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbAEShZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:37:25 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot/video-mode: Fix video-mode.c path in comment
Date: Tue,  6 Jan 2015 00:37:09 +0600
Message-Id: <1420483029-14454-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.212.gc5b9256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/video-mode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/video-mode.c b/arch/x86/boot/video-mode.c
index 748e8d0..74338d5 100644
--- a/arch/x86/boot/video-mode.c
+++ b/arch/x86/boot/video-mode.c
@@ -9,7 +9,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * arch/i386/boot/video-mode.c
+ * arch/x86/boot/video-mode.c
  *
  * Set the video mode.  This is separated out into a different
  * file in order to be shared with the ACPI wakeup code.
-- 
2.2.1.212.gc5b9256

