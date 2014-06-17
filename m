Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967492AbaFQW0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:26:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965630AbaFQVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 177/212] Input: synaptics - T540p - unify with other LEN0034 models
Date: Tue, 17 Jun 2014 14:44:31 -0700
Message-Id: <1403041506-13646-178-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 6d396ede224dc596d92d7cab433713536e68916c upstream.

The T540p has a touchpad with pnp-id LEN0034, all the models with this
pnp-id have the same min/max values, except the T540p where the values are
slightly off. Fix them to be identical.

This is a preparation patch for simplifying the quirk table.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/synaptics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index fa1dee5..f6fbba5 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1552,7 +1552,7 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
 		},
-		.driver_data = (int []){1024, 5056, 2058, 4832},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
 		/* Lenovo ThinkPad L540 */
-- 
1.9.1

