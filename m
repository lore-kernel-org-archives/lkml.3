Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaIQVs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:48:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33535 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbaIQVsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:48:23 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] eeepc-laptop: clean up coding style
Date: Wed, 17 Sep 2014 23:47:19 +0200
Message-Id: <1410990447-3210-2-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
References: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct indentation and brace usage to comply with
Documentation/CodingStyle.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 3095d38..653999e 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -544,7 +544,7 @@ static int eeepc_led_init(struct eeepc_laptop *eeepc)
 	eeepc->tpd_led.name = "eeepc::touchpad";
 	eeepc->tpd_led.brightness_set = tpd_led_set;
 	if (get_acpi(eeepc, CM_ASL_TPD) >= 0) /* if method is available */
-	  eeepc->tpd_led.brightness_get = tpd_led_get;
+		eeepc->tpd_led.brightness_get = tpd_led_get;
 	eeepc->tpd_led.max_brightness = 1;
 
 	rv = led_classdev_register(&eeepc->platform_device->dev,
@@ -692,8 +692,9 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
 		 * changed during setup.
 		 */
 		eeepc_rfkill_hotplug(eeepc, handle);
-	} else
+	} else {
 		return -ENODEV;
+	}
 
 	return 0;
 }
@@ -1424,8 +1425,9 @@ static int eeepc_acpi_add(struct acpi_device *device)
 		result = eeepc_backlight_init(eeepc);
 		if (result)
 			goto fail_backlight;
-	} else
+	} else {
 		pr_info("Backlight controlled by ACPI video driver\n");
+	}
 
 	result = eeepc_input_init(eeepc);
 	if (result)
-- 
2.1.0

