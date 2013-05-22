Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3EVQ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:28:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab3EVQ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:28:16 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
Date: Wed, 22 May 2013 18:28:37 +0200
Message-Id: <1369240118-5459-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usermode helper is mandatory for this driver.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/firmware/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9387630..0747872 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -64,6 +64,7 @@ config DELL_RBU
 	tristate "BIOS update support for DELL systems via sysfs"
 	depends on X86
 	select FW_LOADER
+	select FW_LOADER_USER_HELPER
 	help
 	 Say m if you want to have the option of updating the BIOS for your
 	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)
-- 
1.8.2.3

