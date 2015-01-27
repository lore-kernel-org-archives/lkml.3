Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbbA0M1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:27:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497AbbA0MTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 100/126] uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013
Date: Tue, 27 Jan 2015 12:16:45 +0000
Message-Id: <1422361031-19364-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit e5797a3d079f3e5049140055d850691b5cc7d10a upstream.

This is yet another Seagate device which needs the US_FL_NO_ATA_1X quirk

Reported-by: Marcin Zajączkowski <mszpak@wp.pl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 18a283d6de1c..2918376a1979 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -68,6 +68,13 @@ UNUSUAL_DEV(0x0bc2, 0xa003, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Marcin Zajączkowski <mszpak@wp.pl> */
+UNUSUAL_DEV(0x0bc2, 0xa013, 0x0000, 0x9999,
+		"Seagate",
+		"Backup Plus",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* https://bbs.archlinux.org/viewtopic.php?id=183190 */
 UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
 		"Seagate",
-- 
2.1.4

