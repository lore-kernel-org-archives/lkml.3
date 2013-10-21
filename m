Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3JUD64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:58:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52866 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3JUD6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:58:53 -0400
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, adurbin@chromium.org,
        dlaurie@chromium.org, olofj@chromium.org, enselic@gmail.com
Cc: bleung@chromium.org
Subject: [PATCH 4/6] Platform: x86: chromeos_laptop - Add names of Haswell ULT i2c busses
Date: Sun, 20 Oct 2013 20:58:27 -0700
Message-Id: <1382327909-6140-5-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382327909-6140-1-git-send-email-bleung@chromium.org>
References: <1382327909-6140-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The designware-pci i2c busses will be named "i2c-designware-pci-0"
and "i2c-designware-pci-1" accordingly.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 1c2747f..57ded03 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -45,6 +45,8 @@ const char *i2c_adapter_names[] = {
 	"SMBus I801 adapter",
 	"i915 gmbus vga",
 	"i915 gmbus panel",
+	"i2c-designware-pci-0",
+	"i2c-designware-pci-1",
 };
 
 /* Keep this enum consistent with i2c_adapter_names */
@@ -52,6 +54,8 @@ enum i2c_adapter_type {
 	I2C_ADAPTER_SMBUS = 0,
 	I2C_ADAPTER_VGADDC,
 	I2C_ADAPTER_PANEL,
+	I2C_ADAPTER_I2C0,
+	I2C_ADAPTER_I2C1,
 };
 
 struct i2c_peripheral {
-- 
1.8.3.2

