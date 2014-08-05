Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaHEH4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:56:36 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:39341 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402AbaHEH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:56:33 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] tty: serial: msm: Fix 'void function return statements are not generally useful' warning
Date: Tue,  5 Aug 2014 13:22:03 +0530
Message-Id: <1407225124-25074-6-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch.pl warning:

WARNING: void function return statements are not generally useful

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index dfebbaf..26df038 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -787,8 +787,6 @@ static void msm_poll_put_char(struct uart_port *port, unsigned char c)
 
 	/* Enable interrupts */
 	msm_write(port, imr, UART_IMR);
-
-	return;
 }
 #endif
 
-- 
1.7.9.5

