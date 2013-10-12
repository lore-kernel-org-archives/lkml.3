Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3JLWLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:11:32 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:47803 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3JLWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:11:31 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@rjwysocki.net,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] ACPI: remove /proc/acpi/event from ACPI_BUTTON help
Date: Sun, 13 Oct 2013 00:11:00 +0200
Message-Id: <1381615860-1882-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.652.g0d6e0ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 1696d9dc57e062ce5200f6a42a6aaada15b434bb
("ACPI: Remove the old /proc/acpi/event interface")
removed the old /proc/acpi/event interface but did not remove
/proc/acpi/event from ACPI_BUTTON help.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 drivers/acpi/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 22327e6..4e9e98b 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -123,9 +123,9 @@ config ACPI_BUTTON
 	default y
 	help
 	  This driver handles events on the power, sleep, and lid buttons.
-	  A daemon reads /proc/acpi/event and perform user-defined actions
-	  such as shutting down the system.  This is necessary for
-	  software-controlled poweroff.
+	  A daemon reads events from input devices or via netlink and
+	  perform user-defined actions such as shutting down the system.
+	  This is necessary for software-controlled poweroff.
 
 	  To compile this driver as a module, choose M here:
 	  the module will be called button.
-- 
1.8.4.652.g0d6e0ce

