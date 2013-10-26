Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3JZUl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:41:27 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40566 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3JZUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:40:39 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, pali.rohar@gmail.com
Subject: [PATCH 14/16] wl1251: add nvs file name to module firmware list
Date: Sat, 26 Oct 2013 22:34:13 +0200
Message-Id: <1382819655-30430-15-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index f054741..7b9efc8 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1709,3 +1709,4 @@ MODULE_DESCRIPTION("TI wl1251 Wireles LAN Driver Core");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
 MODULE_FIRMWARE(WL1251_FW_NAME);
+MODULE_FIRMWARE(WL1251_NVS_NAME);
-- 
1.7.10.4

