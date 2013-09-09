Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3IIS7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:59:55 -0400
Received: from mailrelay02.solcon.nl ([212.45.32.108]:43805 "EHLO
	mailrelay02.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3IIS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:59:54 -0400
X-Greylist: delayed 1395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 14:59:53 EDT
From: Albert Pool <albertpool@solcon.nl>
To: Pontus Fuchs <pontus.fuchs@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Albert Pool <albertpool@solcon.nl>
Subject: [PATCH] ar5523: Add USB ID of D-Link WUA-2340 rev A1
Date: Mon,  9 Sep 2013 20:36:30 +0200
Message-Id: <1378751790-2465-1-git-send-email-albertpool@solcon.nl>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Albert Pool <albertpool@solcon.nl>
Reported-by: Michael Landrum <landrummd@gmail.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 17d7fec..280fc3d 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1762,6 +1762,7 @@ static struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UX(0x2001, 0x3a00),	/* Dlink / DWLAG132 */
 	AR5523_DEVICE_UG(0x2001, 0x3a02),	/* Dlink / DWLG132 */
 	AR5523_DEVICE_UX(0x2001, 0x3a04),	/* Dlink / DWLAG122 */
+	AR5523_DEVICE_UG(0x07d1, 0x3a07),	/* D-Link / WUA-2340 rev A1 */
 	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
 	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
 	AR5523_DEVICE_UG(0x129b, 0x160c),	/* Gigaset / USB stick 108
-- 
1.7.10.4

