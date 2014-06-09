Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbaFIJOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:14:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58425 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniele Forsi <dforsi@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 060/146] USB: Nokia 5300 should be treated as unusual dev
Date: Mon,  9 Jun 2014 10:49:55 +0200
Message-Id: <d1dc82b867de4af7be4e345349a43147f41683a5.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniele Forsi <dforsi@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6ed07d45d09bc2aa60e27b845543db9972e22a38 upstream.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1010341792a2..042c83b01046 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -234,6 +234,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x0370,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Daniele Forsi <dforsi@gmail.com> */
+UNUSUAL_DEV(  0x0421, 0x04b9, 0x0350, 0x0350,
+		"Nokia",
+		"5300",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 /* Patch submitted by Victor A. Santos <victoraur.santos@gmail.com> */
 UNUSUAL_DEV(  0x0421, 0x05af, 0x0742, 0x0742,
 		"Nokia",
-- 
1.9.3

