Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaBTXv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:51:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaBTXvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 15/82] ar5523: fix usb id for Gigaset.
Date: Thu, 20 Feb 2014 15:51:58 -0800
Message-Id: <20140220235019.943442115@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit 4fcfc7443d072582b5047b8b391d711590e5645c upstream.

Raw id and FW id should be switched.

Tested-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ar5523/ar5523.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1764,7 +1764,7 @@ static struct usb_device_id ar5523_id_ta
 	AR5523_DEVICE_UX(0x2001, 0x3a04),	/* Dlink / DWLAG122 */
 	AR5523_DEVICE_UG(0x1690, 0x0712),	/* Gigaset / AR5523 */
 	AR5523_DEVICE_UG(0x1690, 0x0710),	/* Gigaset / SMCWUSBTG */
-	AR5523_DEVICE_UG(0x129b, 0x160c),	/* Gigaset / USB stick 108
+	AR5523_DEVICE_UG(0x129b, 0x160b),	/* Gigaset / USB stick 108
 						   (CyberTAN Technology) */
 	AR5523_DEVICE_UG(0x16ab, 0x7801),	/* Globalsun / AR5523_1 */
 	AR5523_DEVICE_UX(0x16ab, 0x7811),	/* Globalsun / AR5523_2 */


