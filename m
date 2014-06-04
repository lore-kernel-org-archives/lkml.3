Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaFDXgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:36:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaFDXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 066/103] Input: synaptics - T540p - unify with other LEN0034 models
Date: Wed,  4 Jun 2014 16:25:29 -0700
Message-Id: <20140604232548.959247146@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 6d396ede224dc596d92d7cab433713536e68916c upstream.

The T540p has a touchpad with pnp-id LEN0034, all the models with this
pnp-id have the same min/max values, except the T540p where the values are
slightly off. Fix them to be identical.

This is a preparation patch for simplifying the quirk table.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1552,7 +1552,7 @@ static const struct dmi_system_id min_ma
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
 		},
-		.driver_data = (int []){1024, 5056, 2058, 4832},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
 		/* Lenovo ThinkPad L540 */


