Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbbADG7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 01:59:34 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:51915 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbADG7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 01:59:31 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] staging: rtl8192e: Fix duplicated conditional branch
Date: Sun,  4 Jan 2015 12:59:15 +0600
Message-Id: <1420354755-5261-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 885315c..9010d0f 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -1661,7 +1661,7 @@ void dm_change_dynamic_initgain_thresh(struct net_device *dev,
 		dm_digtable.rssi_low_thresh = dm_value;
 	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
 		dm_digtable.rssi_high_power_highthresh = dm_value;
-	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
+	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_LOW) {
 		dm_digtable.rssi_high_power_highthresh = dm_value;
 	} else if (dm_type == DIG_TYPE_ENABLE) {
 		dm_digtable.dig_state		= DM_STA_DIG_MAX;
-- 
2.2.1.202.g44ae4ee.dirty

