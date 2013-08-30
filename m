Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3H3VUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:20:45 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:45620 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3H3VUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:20:44 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Kosina <trivial@kernel.org>,
        linux-acpi@vger.kernel.org (open list:ACPI FAN DRIVER)
Subject: [PATCH] acpi: fan: trivial style cleanup
Date: Fri, 30 Aug 2013 16:16:05 -0500
Message-Id: <1377897365-2774-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4-fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 5b02a0a..0898649 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -168,7 +168,7 @@ static int acpi_fan_add(struct acpi_device *device)
 	       acpi_device_name(device), acpi_device_bid(device),
 	       !device->power.state ? "on" : "off");
 
-      end:
+end:
 	return result;
 }
 
-- 
1.8.4-fc

