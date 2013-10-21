Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3JUXyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:54:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:53123 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab3JUXyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:54:07 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/2] tpm: Fix module name description in Kconfig for tpm_i2c_*
Date: Tue, 22 Oct 2013 01:53:47 +0200
Message-Id: <1382399628-28409-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
X-Provags-ID: V03:K0:VjfnWD0a016H3SLFKMrUn7yha967vPHKwi31rMTcZzWQGN9ly6s
 1EtyoOl1LVS6Sj8YWwCfzEJ8fBwwkPMPopD8wxt80OI9gHWX42iBuVKH9c1tlJpaBjKzoO3
 hV4yM3Q5r1wFVP8U1JusMx8Ftjt4BtoF4XrLCpzhGJuG/NGIAUhWx5LgmiqbkEk4wzp5Gt4
 do+OYBtRa52qbjUBB9y8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the displayed module name from
tpm_tis_i2c_infineon to its actual name tpm_i2c_infineon
and from tpm_stm_st33_i2c to tpm_i2c_stm_st33

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f908586..4716af5 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -51,7 +51,7 @@ config TCG_TIS_I2C_INFINEON
 	  Specification 0.20 say Yes and it will be accessible from within
 	  Linux.
 	  To compile this driver as a module, choose M here; the module
-	  will be called tpm_tis_i2c_infineon.
+	  will be called tpm_i2c_infineon.
 
 config TCG_TIS_I2C_NUVOTON
 	tristate "TPM Interface Specification 1.2 Interface (I2C - Nuvoton)"
@@ -108,7 +108,7 @@ config TCG_ST33_I2C
         If you have a TPM security chip from STMicroelectronics working with
         an I2C bus say Yes and it will be accessible from within Linux.
         To compile this driver as a module, choose M here; the module will be
-        called tpm_stm_st33_i2c.
+        called tpm_i2c_stm_st33.
 
 config TCG_XEN
 	tristate "XEN TPM Interface"
-- 
1.7.5.4

