Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaBUAyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:54:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbaBTXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Subject: [PATCH 3.10 44/66] usb-storage: add unusual-devs entry for BlackBerry 9000
Date: Thu, 20 Feb 2014 15:51:43 -0800
Message-Id: <20140220234910.753039940@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c5637e5119c43452a00e27c274356b072263ecbb upstream.

This patch adds an unusual-devs entry for the BlackBerry 9000.  This
fixes Bugzilla #22442.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Tested-by: Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1455,6 +1455,13 @@ UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0
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


