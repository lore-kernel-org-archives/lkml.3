Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635Ab3CZQXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:23:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934679Ab3CZPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/150] qcaux: add Franklin U600
Date: Tue, 26 Mar 2013 15:18:26 +0000
Message-Id: <1364311249-14454-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 2d90e63603ac235aecd7d20e234616e0682c8b1f upstream.

4 ports; AT/PPP is standard CDC-ACM.  The other three (added by this
patch) are QCDM/DIAG, possibly GPS, and unknown.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/qcaux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcaux.c b/drivers/usb/serial/qcaux.c
index 9b1b96f..31f81c3 100644
--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -69,6 +69,7 @@ static struct usb_device_id id_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xfd, 0xff) },  /* NMEA */
 	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xfe, 0xff) },  /* WMC */
 	{ USB_VENDOR_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, 0xff, 0xff, 0xff) },  /* DIAG */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1fac, 0x0151, 0xff, 0xff, 0xff) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
1.8.1.2

