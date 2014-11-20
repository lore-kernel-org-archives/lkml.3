Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaKTM5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:57:47 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52149 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaKTM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:57:45 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: axp20x: Constify axp20x_acpi_match and rid unused warning
Date: Thu, 20 Nov 2014 12:57:28 +0000
Message-Id: <1416488248-24246-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

axp20x.c:239:30:
  warning: ‘axp20x_acpi_match’ defined but not used [-Wunused-variable]

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 971b0eb..c522ee2 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -236,7 +236,7 @@ static const struct i2c_device_id axp20x_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
 
-static struct acpi_device_id axp20x_acpi_match[] = {
+static const struct acpi_device_id axp20x_acpi_match[] = {
 	{
 		.id = "INT33F4",
 		.driver_data = AXP288_ID,
-- 
1.9.1

