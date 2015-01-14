Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbbANI0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:26:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbbANH2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>
Subject: [PATCH 3.18 095/150] tty: serial: men_z135_uart: Add terminating entry for men_z135_ids
Date: Tue, 13 Jan 2015 23:22:46 -0800
Message-Id: <20150114072100.183476374@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 6b1f40cf4840820051d69646af0b6503878cb1bc upstream.

The mcb_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/men_z135_uart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -809,6 +809,7 @@ static void men_z135_remove(struct mcb_d
 
 static const struct mcb_device_id men_z135_ids[] = {
 	{ .device = 0x87 },
+	{ }
 };
 MODULE_DEVICE_TABLE(mcb, men_z135_ids);
 


