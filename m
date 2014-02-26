Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaBZWo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:44:29 -0500
Received: from arlo.cworth.org ([50.126.95.6]:51970 "EHLO arlo.cworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbaBZWo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:44:27 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2014 17:44:27 EST
From: Carl Worth <cworth@cworth.org>
To: Ping Cheng <pingc@wacom.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carl Worth <cworth@cworth.org>
Subject: [PATCH 1/3] Input: wacom - EC tablet supports 1023 levels of pressure, not just 255
Date: Wed, 26 Feb 2014 14:38:14 -0800
Message-Id: <1393454296-32735-2-git-send-email-cworth@cworth.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393454296-32735-1-git-send-email-cworth@cworth.org>
References: <1393454296-32735-1-git-send-email-cworth@cworth.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was verified on a ThinkPad Yoga laptop with an integrated Wacom
tablet which reports itself with an ID of 0xEC.

Signed-off-by: Carl Worth <cworth@cworth.org>
---
 drivers/input/tablet/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 782c253..4958081 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -2109,7 +2109,7 @@ static const struct wacom_features wacom_features_0xE6 =
 	  0, TABLETPC2FG, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
 	  .touch_max = 2 };
 static const struct wacom_features wacom_features_0xEC =
-	{ "Wacom ISDv4 EC",       WACOM_PKGLEN_GRAPHIRE,  25710, 14500,  255,
+	{ "Wacom ISDv4 EC",       WACOM_PKGLEN_GRAPHIRE,  25710, 14500,  1023,
 	  0, TABLETPC,    WACOM_INTUOS_RES, WACOM_INTUOS_RES };
 static const struct wacom_features wacom_features_0xED =
 	{ "Wacom ISDv4 ED",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,
-- 
1.9.0

