Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaKYLqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:46:47 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40495 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaKYLqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:46:44 -0500
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: matt@ninezulu.com, raghav3276@gmail.com, josh@joshtriplett.org,
        tapaswenipathak@gmail.com, vitaly.osipov@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi C V <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:wlan-ng: Fixed checkpatch warning
Date: Tue, 25 Nov 2014 17:16:40 +0530
Message-Id: <1416916000-4243-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following checkpatch warning was fixed
WARNING: line over 80 characters

Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index e907380..8e1da3c 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -238,7 +238,8 @@ static int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 *	0	- success
 *	~0	- failure
 ----------------------------------------------------------------*/
-static int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
+static int prism2_fwapply(const struct ihex_binrec *rfptr,
+	      wlandevice_t *wlandev)
 {
 	signed int result = 0;
 	struct p80211msg_dot11req_mibget getmsg;
@@ -707,7 +708,9 @@ static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 			continue;
 		}
 
-		/* Validate plug address against chunk data and identify chunk */
+		/* Validate plug address against chunk data and
+		 * identify chunk
+		 */
 		for (c = 0; c < nfchunks; c++) {
 			cstart = fchunk[c].addr;
 			cend = fchunk[c].addr + fchunk[c].len;
@@ -922,7 +925,8 @@ static int read_fwfile(const struct ihex_binrec *record)
 				      rcnt,
 				      s3info[ns3info].len,
 				      s3info[ns3info].type);
-			if (((s3info[ns3info].len - 1) * sizeof(u16)) > sizeof(s3info[ns3info].info)) {
+			if (((s3info[ns3info].len - 1) * sizeof(u16)) >
+			      sizeof(s3info[ns3info].info)) {
 				pr_err("S3 inforec length too long - aborting\n");
 				return 1;
 			}
-- 
1.7.9.5

