Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaIWPZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:25:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54086 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaIWPZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:25:20 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
X-Google-Original-From: Marcos Paulo de Souza
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Tom Gundersen <teg@jklm.no>, Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] input/serio/i8042-x86ia64io.h: Fix Asus X450LCP touchpad detection
Date: Tue, 23 Sep 2014 12:24:33 -0300
Message-Id: <1411485873-4245-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Peter Hutterer <peter.hutterer@who-t.net>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/input/serio/i8042-x86ia64io.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 136b7b20..ec6cb72 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -465,6 +465,15 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Asus X450LCP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X450LCP"),
+		},
+	},
+
+
 	{ }
 };
 
-- 
1.9.3

