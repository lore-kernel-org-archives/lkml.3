Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaLaN4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:56:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44299 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaLaN4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:56:46 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot/early_serial_console: Remove unused macro XMTRDY
Date: Wed, 31 Dec 2014 19:56:31 +0600
Message-Id: <1420034191-20721-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no write to serial routine, no need in XMTRDY macro.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/early_serial_console.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..790586d 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -2,8 +2,6 @@
 
 #define DEFAULT_SERIAL_PORT 0x3f8 /* ttyS0 */
 
-#define XMTRDY          0x20
-
 #define DLAB		0x80
 
 #define TXR             0       /*  Transmit register (WRITE) */
-- 
2.2.1.202.g44ae4ee.dirty

