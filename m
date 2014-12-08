Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaLIIuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:50:12 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60943 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaLIIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:50:10 -0500
From: Adithya K <linux.challenge1@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        gclement@baobob.org, joe@perches.com, guido@vanguardiasur.com.ar,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Adithya Krishnamurthy <linux.challenge@gmail.com>,
        Adithya Krishnamurthy <linux.challenge1@gmail.com>
Subject: [PATCH 1/1] [PATCH] Staging:vt6655: sparse warning fix
Date: Mon,  8 Dec 2014 23:33:25 +0530
Message-Id: <1418061805-19768-1-git-send-email-linux.challenge1@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adithya Krishnamurthy <linux.challenge@gmail.com>

Fixed sparse warning fix.

Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
---
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 83e4162..a3f5cd8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1669,7 +1669,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
 	.reset_tsf		= vnt_reset_tsf,
 };
 
-int vnt_init(struct vnt_private *priv)
+static int vnt_init(struct vnt_private *priv)
 {
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyCurrentNetAddr);
 
-- 
1.9.1

