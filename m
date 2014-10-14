Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaJNVrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:47:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63710 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaJNVq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:46:58 -0400
From: Benson Leung <bleung@chromium.org>
To: jkosina@suse.cz, benjamin.tissoires@redhat.com, aduggan@synaptics.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, bleung@chromium.org, satoshi.noguchi@jp.synaptics.com,
        dmitry.torokhov@gmail.com
Subject: [PATCH] HID: i2c-hid: Add hid-over-i2c name to i2c id table.
Date: Tue, 14 Oct 2014 14:44:01 -0700
Message-Id: <1413323041-19468-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the device tree binding of compatible = "hid-over-i2c"
the i2c id table also needs to have that name in order to
auto load this driver.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/hid/i2c-hid/i2c-hid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 747d544..1a7605f 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -1123,6 +1123,7 @@ static const struct dev_pm_ops i2c_hid_pm = {
 
 static const struct i2c_device_id i2c_hid_id_table[] = {
 	{ "hid", 0 },
+	{ "hid-over-i2c", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, i2c_hid_id_table);
-- 
2.1.0.rc2.206.gedb03e5

