Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbbAXNcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 08:32:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55777 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbAXNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 08:31:59 -0500
Message-ID: <1422106315.5576.2.camel@phoenix>
Subject: [PATCH] regulator: Fix documentation for regmap in the config
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 24 Jan 2015 21:31:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/regulator/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index d4ad5b5..045f709 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -316,7 +316,7 @@ struct regulator_desc {
  * @driver_data: private regulator data
  * @of_node: OpenFirmware node to parse for device tree bindings (may be
  *           NULL).
- * @regmap: regmap to use for core regmap helpers if dev_get_regulator() is
+ * @regmap: regmap to use for core regmap helpers if dev_get_regmap() is
  *          insufficient.
  * @ena_gpio_initialized: GPIO controlling regulator enable was properly
  *                        initialized, meaning that >= 0 is a valid gpio
-- 
1.9.1



