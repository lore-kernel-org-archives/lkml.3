Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaBUMuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaBUMu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 058/121] ar5523: fix usb id for Gigaset.
Date: Fri, 21 Feb 2014 12:48:02 +0000
Message-Id: <1392986945-9693-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit 4fcfc7443d072582b5047b8b391d711590e5645c upstream.

Raw id and FW id should be switched.

Tested-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 17d7fec..57fc06e 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1764,7 +1764,7 @@ static struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UX(0x2001, 0x3a04),	/* Dlink / DWLAG122 */
 	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
 	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
-	AR5523_DEVICE_UG(0x129b, 0x160c),	/* Gigaset / USB stick 108
+	AR5523_DEVICE_UG(0x129b, 0x160b),	/* Gigaset / USB stick 108
 						   (CyberTAN Technology) */
 	AR5523_DEVICE_UG(0x16ab, 0x7801),	/* Globalsun / AR5523_1 */
 	AR5523_DEVICE_UX(0x16ab, 0x7811),	/* Globalsun / AR5523_2 */
-- 
1.9.0

