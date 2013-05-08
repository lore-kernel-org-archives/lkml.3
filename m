Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3EHG4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:56:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3EHG4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:56:48 -0400
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 3/3] dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
Date: Wed,  8 May 2013 08:56:37 +0200
Message-Id: <1367996197-32748-4-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367996197-32748-1-git-send-email-tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
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
1.8.2.1

