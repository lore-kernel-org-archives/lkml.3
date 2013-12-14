Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3LNRba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:30 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65282 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3LNRau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:50 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 11/14] i8k: Add support for Dell XPS M140
Date: Sat, 14 Dec 2013 09:30:18 -0800
Message-Id: <1387042221-3671-12-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index b35ccaa..bd11dac 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -692,6 +692,13 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Studio"),
 		},
 	},
+	{
+		.ident = "Dell XPS M140",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.9.7

