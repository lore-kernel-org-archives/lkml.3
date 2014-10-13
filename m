Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaJMCft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:35:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaJMCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.17 15/25] uas: Add US_FL_NO_ATA_1X quirk for Seagate (0bc2:ab20) drives
Date: Mon, 13 Oct 2014 04:25:08 +0200
Message-Id: <20141013022454.948023904@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit f9554a6b199360c2f888173fd600e1eb7ff165ef upstream.

https://bbs.archlinux.org/viewtopic.php?pid=1457492

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -54,6 +54,13 @@ UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* https://bbs.archlinux.org/viewtopic.php?id=183190 */
+UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
+		"Seagate",
+		"Backup+ BK",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Claudio Bizzarri <claudio.bizzarri@gmail.com> */
 UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
 		"JMicron",


