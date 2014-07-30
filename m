Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaG3M44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:56:56 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:54199 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbaG3M4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:56:37 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: stern@rowland.harvard.edu
Cc: gregkh@linuxfoundation.org, kiran.padwal@smartplayin.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] usb: host: ehci-msm: Make of_device_id array const
Date: Wed, 30 Jul 2014 18:14:45 +0530
Message-Id: <1406724285-14641-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/usb/host/ehci-msm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 982c09b..934b39d 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -190,7 +190,7 @@ static const struct dev_pm_ops ehci_msm_dev_pm_ops = {
 	.resume          = ehci_msm_pm_resume,
 };
 
-static struct of_device_id msm_ehci_dt_match[] = {
+static const struct of_device_id msm_ehci_dt_match[] = {
 	{ .compatible = "qcom,ehci-host", },
 	{}
 };
-- 
1.7.9.5

