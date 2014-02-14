Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBNOZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:25:46 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58453 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBNOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:25:44 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        jic23@kernel.org
Cc: pmeerw@pmeerw.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/2] staging: iio: hmc5843: Add all available models to device tree id table.
Date: Fri, 14 Feb 2014 15:25:28 +0100
Message-Id: <1392387929-31491-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/staging/iio/magnetometer/hmc5843.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
index d4f4dd9..f595fdc 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.c
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -630,7 +630,9 @@ static const struct i2c_device_id hmc5843_id[] = {
 MODULE_DEVICE_TABLE(i2c, hmc5843_id);
 
 static const struct of_device_id hmc5843_of_match[] = {
-	{ .compatible = "honeywell,hmc5843" },
+	{ .compatible = "honeywell,hmc5843", .data = (void *)HMC5843_ID },
+	{ .compatible = "honeywell,hmc5883", .data = (void *)HMC5883_ID },
+	{ .compatible = "honeywell,hmc5883l", .data = (void *)HMC5883L_ID },
 	{}
 };
 MODULE_DEVICE_TABLE(of, hmc5843_of_match);
-- 
1.8.3.2

