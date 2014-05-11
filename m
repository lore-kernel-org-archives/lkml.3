Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbaEKT03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbaEKT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 47/48] Input: synaptics - add min/max quirk for ThinkPad Edge E431
Date: Sun, 11 May 2014 21:20:21 +0200
Message-Id: <20140511191954.432670229@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 27a38856a948c3e8de30dc71647ff9e1778c99fc upstream.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1515,6 +1515,14 @@ static const struct dmi_system_id min_ma
 		.driver_data = (int []){1232, 5710, 1156, 4696},
 	},
 	{
+		/* Lenovo ThinkPad Edge E431 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Edge E431"),
+		},
+		.driver_data = (int []){1024, 5022, 2508, 4832},
+	},
+	{
 		/* Lenovo ThinkPad T431s */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),


