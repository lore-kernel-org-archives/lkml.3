Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3BKAUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:20:35 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53089 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3BKAUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:20:32 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH 1/1] Platform: x86: chromeos_laptop - Add HP Pavilion 14
Date: Sun, 10 Feb 2013 16:20:17 -0800
Message-Id: <1360542017-1163-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360542017-1163-1-git-send-email-bleung@chromium.org>
References: <1359758086-2320-1-git-send-email-bleung@chromium.org>
 <1360542017-1163-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the HP Pavilion 14 Chromebook's trackpad, which is a reuse
of the Samsung Series 5 550 trackpad.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 95bf94f..bc6599c 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -207,6 +207,13 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 		.callback = setup_cyapa_smbus_tp,
 	},
 	{
+		.ident = "HP Pavilion 14 Chromebook - Touchpad",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Butterfly"),
+		},
+		.callback = setup_cyapa_smbus_tp,
+	},
+	{
 		.ident = "Samsung Series 5 - Light Sensor",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
-- 
1.8.1

