Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3KYUB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:01:58 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3476 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab3KYUB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:01:57 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Wolfram Sang" <wsa@the-dreams.de>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Guenter Roeck" <linux@roeck-us.net>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Linux I2C List" <linux-i2c@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH] i2c: i2c-bcm-kona: Fix module build
Date: Mon, 25 Nov 2013 12:01:18 -0800
Message-ID: <1385409678-4398-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E8D73034RS11036037-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a typo that prevented the driver from being built as a module.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/i2c/busses/i2c-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm-kona.c
index 036cf03..2fefc24 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -891,7 +891,7 @@ static const struct of_device_id bcm_kona_i2c_of_match[] = {
 	{.compatible = "brcm,kona-i2c",},
 	{},
 };
-MODULE_DEVICE_TABLE(of, kona_i2c_of_match);
+MODULE_DEVICE_TABLE(of, bcm_kona_i2c_of_match);
 
 static struct platform_driver bcm_kona_i2c_driver = {
 	.driver = {
-- 
1.8.0.1


