Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbaFAMTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:33 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44567 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbaFAMT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/26] staging: rtl8188eu: Remove unused enum _IFACE_TYPE
Date: Sun,  1 Jun 2014 17:46:42 +0530
Message-Id: <1401625013-11208-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index f7db553..9195cf3 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -187,12 +187,6 @@ static inline struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
 	return &dvobj->pusbintf->dev;
 };
 
-enum _IFACE_TYPE {
-	IFACE_PORT0, /* mapping to port0 for C/D series chips */
-	IFACE_PORT1, /* mapping to port1 for C/D series chip */
-	MAX_IFACE_PORT,
-};
-
 enum driver_state {
 	DRIVER_NORMAL = 0,
 	DRIVER_DISAPPEAR = 1,
-- 
1.7.10.4

