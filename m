Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424AbaGXITY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:19:24 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:52587 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934357AbaGXIS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFViMQUTkeGYhGAcAOF4V7iVAHFoQwBZszlEKDSjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 08/10 linux-next] USB: serial: remove unnecessary break after return
Date: Thu, 24 Jul 2014 10:18:56 +0200
Message-Id: <1406189939-6433-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/serial/iuu_phoenix.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 5ad4a0f..705e9dd 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -860,7 +860,6 @@ static int iuu_uart_baud(struct usb_serial_port *port, u32 baud_base,
 	default:
 		kfree(dataout);
 		return IUU_INVALID_PARAMETER;
-		break;
 	}
 
 	switch (parity & 0xF0) {
@@ -874,7 +873,6 @@ static int iuu_uart_baud(struct usb_serial_port *port, u32 baud_base,
 	default:
 		kfree(dataout);
 		return IUU_INVALID_PARAMETER;
-		break;
 	}
 
 	status = bulk_immediate(port, dataout, DataCount);
-- 
1.8.4.5

