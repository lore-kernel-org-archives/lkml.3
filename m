Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaCCS6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:58:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaCCS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 33/67] usb-storage: add unusual-devs entry for BlackBerry 9000
Date: Mon,  3 Mar 2014 10:55:21 -0800
Message-Id: <1393872955-28810-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c5637e5119c43452a00e27c274356b072263ecbb upstream.

This patch adds an unusual-devs entry for the BlackBerry 9000.  This
fixes Bugzilla #22442.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Tested-by: Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 3224305..15bb781 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1447,6 +1447,13 @@ UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de> */
+UNUSUAL_DEV(  0x0fca, 0x8004, 0x0201, 0x0201,
+		"Research In Motion",
+		"BlackBerry Bold 9000",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 /* Reported by Michael Stattmann <michael@stattmann.com> */
 UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x0000,
 		"Sony Ericsson",
-- 
1.8.3.2

