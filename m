Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaFLRsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:48:21 -0400
Received: from 200.180.216.87.static.jazztel.es ([87.216.180.200]:45622 "HELO
	mail.sysvalve.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750902AbaFLRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:48:20 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2014 13:48:20 EDT
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: rtl8172u: Make ieee80211_crypto_init static
Date: Thu, 12 Jun 2014 19:40:49 +0200
Message-Id: <1402594851-16941-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 2.0.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
index 5533221..3be690d 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
@@ -200,7 +200,7 @@ static struct ieee80211_crypto_ops ieee80211_crypt_null = {
 	.owner			= THIS_MODULE,
 };
 
-int __init ieee80211_crypto_init(void)
+static int __init ieee80211_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-- 
2.0.0.rc0

