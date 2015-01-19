Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbbASJE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:04:58 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39435 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbASJEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:04:55 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH 1/2] x86/early_serial_console: remove unused definitions
Date: Mon, 19 Jan 2015 15:04:49 +0600
Message-Id: <1421658289-22096-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0.44.ga94655d.dirty
In-Reply-To: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
References: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TXR, RXR, IIR, LSR and MSR are not used anywhere

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
2.3.0.rc0.44.ga94655d.dirty

