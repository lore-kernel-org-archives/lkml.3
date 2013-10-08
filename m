Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3JHDPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:15:01 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43415 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab3JHDOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:14:46 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...)
Subject: [RESEND/PATCH 2/2] x86: asus-laptop: trivial style cleanups
Date: Mon,  7 Oct 2013 22:08:38 -0500
Message-Id: <1381201718-24698-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4-fc
In-Reply-To: <1381201718-24698-1-git-send-email-felipe.contreras@gmail.com>
References: <1381201718-24698-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/platform/x86/asus-laptop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 0e9c169..0210cf4 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1032,7 +1032,7 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
 	return sysfs_acpi_set(asus, buf, count, METHOD_WLAN);
 }
 
-/*e
+/*
  * Bluetooth
  */
 static int asus_bluetooth_set(struct asus_laptop *asus, int status)
@@ -1853,9 +1853,8 @@ static void asus_dmi_check(void)
 		return;
 
 	/* On L1400B WLED control the sound card, don't mess with it ... */
-	if (strncmp(model, "L1400B", 6) == 0) {
+	if (strncmp(model, "L1400B", 6) == 0)
 		wlan_status = -1;
-	}
 }
 
 static bool asus_device_present;
-- 
1.8.4-fc

