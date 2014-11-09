Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaKIBWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:22:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48342 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaKIBWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:22:33 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: cascardo@linux.vnet.ibm.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 5/5] serial: jsm: Fix unnecessary space before function ptr arguments
Date: Sun,  9 Nov 2014 02:22:20 +0100
Message-Id: <1415496140-14997-6-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415496140-14997-5-git-send-email-bergo.torino@gmail.com>
References: <1415496140-14997-1-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-2-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-3-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-4-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-5-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit deals with the checkpatch warning "Unnecessary space before
function pointer arguments".

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/jsm/jsm.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
index 39b325b..0b79b87 100644
--- a/drivers/tty/serial/jsm/jsm.h
+++ b/drivers/tty/serial/jsm/jsm.h
@@ -111,21 +111,21 @@ struct jsm_channel;
  ************************************************************************/
 struct board_ops {
 	irq_handler_t intr;
-	void (*uart_init) (struct jsm_channel *ch);
-	void (*uart_off) (struct jsm_channel *ch);
-	void (*param) (struct jsm_channel *ch);
-	void (*assert_modem_signals) (struct jsm_channel *ch);
-	void (*flush_uart_write) (struct jsm_channel *ch);
-	void (*flush_uart_read) (struct jsm_channel *ch);
-	void (*disable_receiver) (struct jsm_channel *ch);
-	void (*enable_receiver) (struct jsm_channel *ch);
-	void (*send_break) (struct jsm_channel *ch);
-	void (*clear_break) (struct jsm_channel *ch);
-	void (*send_start_character) (struct jsm_channel *ch);
-	void (*send_stop_character) (struct jsm_channel *ch);
-	void (*copy_data_from_queue_to_uart) (struct jsm_channel *ch);
-	u32 (*get_uart_bytes_left) (struct jsm_channel *ch);
-	void (*send_immediate_char) (struct jsm_channel *ch, unsigned char);
+	void (*uart_init)(struct jsm_channel *ch);
+	void (*uart_off)(struct jsm_channel *ch);
+	void (*param)(struct jsm_channel *ch);
+	void (*assert_modem_signals)(struct jsm_channel *ch);
+	void (*flush_uart_write)(struct jsm_channel *ch);
+	void (*flush_uart_read)(struct jsm_channel *ch);
+	void (*disable_receiver)(struct jsm_channel *ch);
+	void (*enable_receiver)(struct jsm_channel *ch);
+	void (*send_break)(struct jsm_channel *ch);
+	void (*clear_break)(struct jsm_channel *ch);
+	void (*send_start_character)(struct jsm_channel *ch);
+	void (*send_stop_character)(struct jsm_channel *ch);
+	void (*copy_data_from_queue_to_uart)(struct jsm_channel *ch);
+	u32 (*get_uart_bytes_left)(struct jsm_channel *ch);
+	void (*send_immediate_char)(struct jsm_channel *ch, unsigned char);
 };
 
 
-- 
1.9.1

