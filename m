Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaKPPtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 10:49:04 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43910 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaKPPtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 10:49:02 -0500
From: Aede Symen Hoekstra <aedesymen@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aede Symen Hoekstra <aedesymen@gmail.com>
Subject: [PATCH] staging: wlan-ng: prism2fw: fixed code style issue
Date: Sun, 16 Nov 2014 16:48:49 +0100
Message-Id: <1416152929-15784-1-git-send-email-aedesymen@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl warning message: line over 80 characters

Signed-off-by: Aede Symen Hoekstra <aedesymen@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index e907380..9408644 100644
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
-- 
1.7.9.5

