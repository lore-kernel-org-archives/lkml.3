Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaI2MoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:44:12 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:34796 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561AbaI2MoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:44:10 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH] usb: phy: msm: Fix Sparse warning
Date: Mon, 29 Sep 2014 18:17:40 +0530
Message-Id: <1411994860-3429-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes below sparse warning:
drivers/usb/phy/phy-msm-usb.c:1397:30:
warning: symbol 'msm_otg_mode_fops' was not declared.Should it be static?

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/usb/phy/phy-msm-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 4bc3fd7..f663f32 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1394,7 +1394,7 @@ out:
 	return status;
 }
 
-const struct file_operations msm_otg_mode_fops = {
+static const struct file_operations msm_otg_mode_fops = {
 	.open = msm_otg_mode_open,
 	.read = seq_read,
 	.write = msm_otg_mode_write,
-- 
1.7.9.5

