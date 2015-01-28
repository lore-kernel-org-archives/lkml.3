Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbbA2JBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757043AbbA2JBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 120/176] Input: I8042 - add Acer Aspire 7738 to the nomux list
Date: Wed, 28 Jan 2015 15:29:10 +0100
Message-Id: <7cf9181b9c762d46eb06a9dfe97cce11bbef4177.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9333caeaeae4f831054e0e127a6ed3948b604d3e upstream.

When KBC is in active multiplexing mode the touchpad on this laptop does
not work.

Reported-by: Bilal Koc <koc.bilo@googlemail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index c92612d5c6d0..c1d156aad8fc 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -415,6 +415,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		},
 	},
 	{
+		/* Acer Aspire 7738 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7738"),
+		},
+	},
+	{
 		/* Gericom Bellagio */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
-- 
2.2.2

