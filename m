Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaK0IsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:41939 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbaK0IsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:08 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 45/91] Input: i8042 - add Fujitsu U574 to no_timeout dmi table
Date: Thu, 27 Nov 2014 16:42:28 +0800
Message-Id: <1417077794-9299-45-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit cc18a69c92d0972bc2fc5a047ee3be1e8398171b upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=69731

Reported-by: Jason Robinson <mail@jasonrobinson.me>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 0ec9abb..dc37b32 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -601,6 +601,14 @@ static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Fujitsu U574 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U574"),
+		},
+	},
 	{ }
 };
 
-- 
1.9.1

