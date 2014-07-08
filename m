Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaGHTsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:48:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54045 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.970237026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 015/125] Input: synaptics - T540p - unify with other
 LEN0034 models
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 6d396ede224dc596d92d7cab433713536e68916c upstream.

The T540p has a touchpad with pnp-id LEN0034, all the models with this
pnp-id have the same min/max values, except the T540p where the values are
slightly off. Fix them to be identical.

This is a preparation patch for simplifying the quirk table.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/synaptics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1431,7 +1431,7 @@ static const struct dmi_system_id min_ma
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T540"),
 		},
-		.driver_data = (int []){1024, 5056, 2058, 4832},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
 		/* Lenovo ThinkPad L540 */

