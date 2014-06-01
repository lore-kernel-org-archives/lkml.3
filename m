Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbaFAMTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:19:45 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56940 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbaFAMTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:19:43 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/26] staging: rtl8188eu: Remove DriverState from struct adapter
Date: Sun,  1 Jun 2014 17:46:44 +0530
Message-Id: <1401625013-11208-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 5fa2e17..de3b70c 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -188,8 +188,6 @@ static inline struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
 };
 
 struct adapter {
-	int	DriverState;/* for disable driver using module, use dongle toi
-			     * replace module. */
 	int	pid[3];/* process id from UI, 0:wps, 1:hostapd, 2:dhcpcd */
 	int	bDongle;/* build-in module or external dongle */
 	u16	chip_type;
-- 
1.7.10.4

