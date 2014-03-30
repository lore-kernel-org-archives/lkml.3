Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaCaADS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:03:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754472AbaC3XnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Moritz Moeller-Herrmann" <moritz-kernel@moeller-herrmann.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.416857749@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 079/200] usb-storage: add unusual-devs entry for
 BlackBerry 9000
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c5637e5119c43452a00e27c274356b072263ecbb upstream.

This patch adds an unusual-devs entry for the BlackBerry 9000.  This
fixes Bugzilla #22442.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Tested-by: Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1441,6 +1441,13 @@ UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0
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

