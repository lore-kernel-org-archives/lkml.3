Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaCKKdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:33:46 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:49894 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaCKKX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: [PATCH trivial 01/16] serial_core: Spelling s/contro/control/
Date: Tue, 11 Mar 2014 11:23:35 +0100
Message-Id: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a91cc2dcb66a..6735e5f074cf 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1764,7 +1764,7 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
 }
 
 /**
- *	uart_parse_options - Parse serial port baud/parity/bits/flow contro.
+ *	uart_parse_options - Parse serial port baud/parity/bits/flow control.
  *	@options: pointer to option string
  *	@baud: pointer to an 'int' variable for the baud rate.
  *	@parity: pointer to an 'int' variable for the parity.
-- 
1.7.9.5

