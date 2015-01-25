Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbbAYS2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:28:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbbAYSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bilal Koc <koc.bilo@googlemail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.18 160/183] Input: I8042 - add Acer Aspire 7738 to the nomux list
Date: Sun, 25 Jan 2015 10:08:02 -0800
Message-Id: <20150125180817.127768080@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 9333caeaeae4f831054e0e127a6ed3948b604d3e upstream.

When KBC is in active multiplexing mode the touchpad on this laptop does
not work.

Reported-by: Bilal Koc <koc.bilo@googlemail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -415,6 +415,13 @@ static const struct dmi_system_id __init
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


