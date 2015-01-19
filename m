Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbbASJFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:05:10 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51527 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbASJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:05:06 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH 2/2] x86/early_printk: remove unused definitions
Date: Mon, 19 Jan 2015 15:05:00 +0600
Message-Id: <1421658300-22150-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0.44.ga94655d.dirty
In-Reply-To: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
References: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RXR, IIR and MSR are not used

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/kernel/early_printk.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 01d1c18..e8f317f 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -83,14 +83,11 @@ static int early_serial_base = 0x3f8;  /* ttyS0 */
 #define DLAB		0x80
 
 #define TXR             0       /*  Transmit register (WRITE) */
-#define RXR             0       /*  Receive register  (READ)  */
 #define IER             1       /*  Interrupt Enable          */
-#define IIR             2       /*  Interrupt ID              */
 #define FCR             2       /*  FIFO control              */
 #define LCR             3       /*  Line control              */
 #define MCR             4       /*  Modem control             */
 #define LSR             5       /*  Line Status               */
-#define MSR             6       /*  Modem Status              */
 #define DLL             0       /*  Divisor Latch Low         */
 #define DLH             1       /*  Divisor latch High        */
 
-- 
2.3.0.rc0.44.ga94655d.dirty

