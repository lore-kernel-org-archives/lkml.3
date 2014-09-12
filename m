Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaILXHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:36 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54672 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaILXHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:10 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] eeepc-laptop: coding style: add curly braces around else compound
Date: Sat, 13 Sep 2014 01:06:42 +0200
Message-Id: <1410563212-31565-4-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 702fcbb..9d8dff9 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1425,8 +1425,9 @@ static int eeepc_acpi_add(struct acpi_device *device)
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

