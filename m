Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaCLMnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:43:20 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63561 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaCLMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, b.zolnierkie@samsung.com,
        linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ahci: st: Standardise naming conventions
Date: Wed, 12 Mar 2014 12:39:38 +0000
Message-Id: <1394627982-23726-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
References: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other devices have adopted similar naming conventions which have been
accepted as the standard. This patch brings any mention of the the ST
AHCI driver into line with them.

Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ata/Kconfig   | 6 +++---
 drivers/ata/ahci_st.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ee7a3dc..ffc5d9d 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -97,12 +97,12 @@ config SATA_AHCI_PLATFORM
 
 	  If unsure, say N.
 
-config SATA_AHCI_ST
-	tristate "ST SATA support"
+config AHCI_ST
+	tristate "ST AHCI SATA support"
 	depends on SATA_AHCI_PLATFORM
 	select GENERIC_PHY
 	help
-	  This option enables support for ST SATA controller.
+	  This option enables support for ST AHCI SATA controller.
 
 	  If unsure, say N.
 
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 2f95133..f5af660 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -235,5 +235,5 @@ module_platform_driver(st_ahci_driver);
 
 MODULE_AUTHOR("Alexandre Torgue <alexandre.torgue@st.com>");
 MODULE_AUTHOR("Francesco Virlinzi <francesco.virlinzi@st.com>");
-MODULE_DESCRIPTION("STMicroelectronics Sata Ahci driver");
+MODULE_DESCRIPTION("STMicroelectronics SATA AHCI Driver");
 MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

