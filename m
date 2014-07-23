Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaGWHl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:41:59 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54952 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaGWHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:41:57 -0400
From: Kiran Padwal <kiran.padwal21@gmail.com>
X-Google-Original-From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: balbi@ti.com, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, kiran.padwal@smartplayin.com
Subject: [PATCH] usb: phy: msm: Make of_device_id array const
Date: Wed, 23 Jul 2014 13:08:22 +0530
Message-Id: <1406101102-11894-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/usb/phy/phy-msm-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 78cc870..e4108ee 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1429,7 +1429,7 @@ static void msm_otg_debugfs_cleanup(void)
 	debugfs_remove(msm_otg_dbg_root);
 }
 
-static struct of_device_id msm_otg_dt_match[] = {
+static const struct of_device_id msm_otg_dt_match[] = {
 	{
 		.compatible = "qcom,usb-otg-ci",
 		.data = (void *) CI_45NM_INTEGRATED_PHY
-- 
1.7.9.5

