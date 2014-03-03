Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbaCCS6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:58:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56030 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaCCS6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 28/67] ar5523: fix usb id for Gigaset.
Date: Mon,  3 Mar 2014 10:55:16 -0800
Message-Id: <1393872955-28810-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit 4fcfc7443d072582b5047b8b391d711590e5645c upstream.

Raw id and FW id should be switched.

Tested-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 7157f7d..f06abf3 100644
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
1.8.3.2

