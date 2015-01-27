Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbbA0M0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:26:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35379 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbbA0MTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 102/126] uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures
Date: Tue, 27 Jan 2015 12:16:47 +0000
Message-Id: <1422361031-19364-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 3ca8c717429b90f621aed28af029da4c3da378bc upstream.

Just like all previous UAS capable Seagate disk enclosures, these need the
US_FL_NO_ATA_1X to not crash when udev probes them.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/unusual_uas.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 2f0a3d35269a..1f430bb02ca1 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -75,6 +75,13 @@ UNUSUAL_DEV(0x0bc2, 0xa013, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x0bc2, 0xa0a4, 0x0000, 0x9999,
+		"Seagate",
+		"Backup Plus Desk",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* https://bbs.archlinux.org/viewtopic.php?id=183190 */
 UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
 		"Seagate",
@@ -89,6 +96,13 @@ UNUSUAL_DEV(0x0bc2, 0xab21, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: G. Richard Bellamy <rbellamy@pteradigm.com> */
+UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
+		"Seagate",
+		"BUP Fast HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Claudio Bizzarri <claudio.bizzarri@gmail.com> */
 UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
 		"JMicron",
-- 
2.1.4

