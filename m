Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaKWJ5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 04:57:08 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47677 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaKWJ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 04:57:06 -0500
From: Lekshmi <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: matt@ninezulu.com, raghav3276@gmail.com, josh@joshtriplett.org,
        tapaswenipathak@gmail.com, vitaly.osipov@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:wlan-ng: Fixed line over 80 characters warning
Date: Sun, 23 Nov 2014 15:26:54 +0530
Message-Id: <1416736614-3873-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following chaeckpatch warning was fixed:
WARNING: line over 80 characters

Signed-off-by: Lekshmi <andnlnbn18@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index e907380..5c3fd2d 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -238,7 +238,8 @@ static int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 *	0	- success
 *	~0	- failure
 ----------------------------------------------------------------*/
-static int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
+static int prism2_fwapply(const struct ihex_binrec *rfptr,
+			  wlandevice_t *wlandev)
 {
 	signed int result = 0;
 	struct p80211msg_dot11req_mibget getmsg;
@@ -707,7 +708,8 @@ static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 			continue;
 		}
 
-		/* Validate plug address against chunk data and identify chunk */
+		/* Validate plug address against chunk data
+		 * and identify chunk */
 		for (c = 0; c < nfchunks; c++) {
 			cstart = fchunk[c].addr;
 			cend = fchunk[c].addr + fchunk[c].len;
-- 
1.7.9.5

