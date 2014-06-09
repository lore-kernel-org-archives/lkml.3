Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaFIJOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:14:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58423 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Victor A. Santos" <victoraur.santos@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/146] USB: Nokia 305 should be treated as unusual dev
Date: Mon,  9 Jun 2014 10:49:54 +0200
Message-Id: <ddf580935a8ca64903aea17da7a323e02d3fbaa7.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Victor A. Santos" <victoraur.santos@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f0ef5d41792a46a1085dead9dfb0bdb2c574638e upstream.

Signed-off-by: Victor A. Santos <victoraur.santos@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index adbeb255616a..1010341792a2 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -234,6 +234,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x0370,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Patch submitted by Victor A. Santos <victoraur.santos@gmail.com> */
+UNUSUAL_DEV(  0x0421, 0x05af, 0x0742, 0x0742,
+		"Nokia",
+		"305",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Patch submitted by Mikhail Zolotaryov <lebon@lebon.org.ua> */
 UNUSUAL_DEV(  0x0421, 0x06aa, 0x1110, 0x1110,
 		"Nokia",
-- 
1.9.3

