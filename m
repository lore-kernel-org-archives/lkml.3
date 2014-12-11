Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbaLKVog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:44:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934420AbaLKVoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:44:30 -0500
Date: Thu, 11 Dec 2014 22:44:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Trivial patch monkey <trivial@kernel.org>
Subject: [PATCH] trivial fixes for omap-serial
Message-ID: <20141211214118.GA2285@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial fixes for omap-serial.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

index 18c30ca..f43ed2c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -63,7 +63,7 @@
 #define UART_ERRATA_i202_MDR1_ACCESS	BIT(0)
 #define UART_ERRATA_i291_DMA_FORCEIDLE	BIT(1)
 
-#define DEFAULT_CLK_SPEED 48000000 /* 48Mhz*/
+#define DEFAULT_CLK_SPEED 48000000 /* 48Mhz */
 
 /* SCR register bitmasks */
 #define OMAP_UART_SCR_RX_TRIG_GRANU1_MASK		(1 << 7)
@@ -93,7 +93,7 @@
 /* WER = 0x7F
  * Enable module level wakeup in WER reg
  */
-#define OMAP_UART_WER_MOD_WKUP	0X7F
+#define OMAP_UART_WER_MOD_WKUP	0x7F
 
 /* Enable XON/XOFF flow control on output */
 #define OMAP_UART_SW_TX		0x08
@@ -114,7 +114,7 @@ struct uart_omap_dma {
 	dma_addr_t		tx_buf_dma_phys;
 	unsigned int		uart_base;
 	/*
-	 * Buffer for rx dma.It is not required for tx because the buffer
+	 * Buffer for rx dma. It is not required for tx because the buffer
 	 * comes from port structure.
 	 */
 	unsigned char		*rx_buf;
@@ -151,7 +151,7 @@ struct uart_omap_port {
 	int			use_dma;
 	/*
 	 * Some bits in registers are cleared on a read, so they must
-	 * be saved whenever the register is read but the bits will not
+	 * be saved whenever the register is read, but the bits will not
 	 * be immediately processed.
 	 */
 	unsigned int		lsr_break_flag;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
