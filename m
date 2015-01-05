Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbbAEGrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:47:02 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:36697 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbbAEGrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:47:00 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot/early_serial_console: remove unused defines
Date: Mon,  5 Jan 2015 12:44:37 +0600
Message-Id: <1420440277-15662-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.476.g2cd1ee5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/early_serial_console.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 5df2869..9176135 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -6,15 +6,10 @@
 
 #define DLAB		0x80
 
-#define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
 #define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
 #define FCR             2       /*  FIFO control              */
 #define LCR             3       /*  Line control              */
 #define MCR             4       /*  Modem control             */
-#define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
 #define DLL             0       /*  Divisor Latch Low         */
 #define DLH             1       /*  Divisor latch High        */
 
-- 
2.2.1.476.g2cd1ee5

