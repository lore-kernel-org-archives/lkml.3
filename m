Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaE2SpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:45:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42880 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaE2SpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:45:12 -0400
Date: Thu, 29 May 2014 20:45:07 +0200
From: Robin Schroer <sulamiification@gmail.com>
To: olof@lixom.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/platform/chrome: coding style fixes
Message-ID: <20140529184507.GA10635@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added blank lines after declarations in some places

Signed-off-by: Robin Schroer <sulamiification@gmail.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 7f1a2e2..0e2785a 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -177,6 +177,7 @@ static int __find_i2c_adap(struct device *dev, void *data)
 	const char *name = data;
 	static const char *prefix = "i2c-";
 	struct i2c_adapter *adapter;
+
 	if (strncmp(dev_name(dev), prefix, strlen(prefix)) != 0)
 		return 0;
 	adapter = to_i2c_adapter(dev);
@@ -231,6 +232,7 @@ static struct i2c_client *add_i2c_device(const char *name,
 						struct i2c_board_info *info)
 {
 	const unsigned short addr_list[] = { info->addr, I2C_CLIENT_END };
+
 	return __add_probed_i2c_device(name,
 				       find_i2c_adapter_num(type),
 				       info,
@@ -464,6 +466,7 @@ static struct platform_driver cros_platform_driver = {
 static int __init chromeos_laptop_init(void)
 {
 	int ret;
+
 	if (!dmi_check_system(chromeos_laptop_dmi_table)) {
 		pr_debug("%s unsupported system.\n", __func__);
 		return -ENODEV;
-- 
1.9.3

