Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab3CGMQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:16:38 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49737 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] TTY: serial/msm_serial_hs, remove unused tty
Date: Thu,  7 Mar 2013 13:12:33 +0100
Message-Id: <1362658360-26629-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/msm_serial_hs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 4a942c7..4ca2f64 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -907,7 +907,6 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 	unsigned int error_f = 0;
 	unsigned long flags;
 	unsigned int flush;
-	struct tty_struct *tty;
 	struct tty_port *port;
 	struct uart_port *uport;
 	struct msm_hs_port *msm_uport;
@@ -919,7 +918,6 @@ static void msm_hs_dmov_rx_callback(struct msm_dmov_cmd *cmd_ptr,
 	clk_enable(msm_uport->clk);
 
 	port = &uport->state->port;
-	tty = port->tty;
 
 	msm_hs_write(uport, UARTDM_CR_ADDR, STALE_EVENT_DISABLE);
 
-- 
1.8.1.4


