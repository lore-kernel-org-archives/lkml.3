Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaBCOXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:23:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38675 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBCOXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:23:44 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH] x86, platform: Make HP_WIRELESS option text more descriptive
Date: Mon,  3 Feb 2014 15:23:40 +0100
Message-Id: <1391437420-5943-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... so that one can know what this option is about without opening the
long help text.

Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/platform/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5ae65c11d544..b022d66e897b 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -198,7 +198,7 @@ config HP_ACCEL
 	  be called hp_accel.
 
 config HP_WIRELESS
-	tristate "HP WIRELESS"
+	tristate "HP wireless button"
 	depends on ACPI
 	depends on INPUT
 	help
-- 
1.8.5.2.192.g7794a68

