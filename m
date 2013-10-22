Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3JVSBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:01:38 -0400
Received: from mout.gmx.net ([212.227.17.21]:56864 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab3JVSBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:01:32 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 15/15] tpm: use tabs instead of whitespaces in Kconfig
Date: Tue, 22 Oct 2013 20:00:40 +0200
Message-Id: <1382464840-7639-15-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
References: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:1lzypkKkc5fZtEUj8H5KUhqoen08KLMBWvJ/0L4nCKjMdW5D2cv
 EquyEWv5DnM8SXscE1YrsBsbIVFTYuwVu2RJbyySiJ//TW6p1kU/kf09fdpH9NjeF/APQvV
 HeZLW3p07ZOV8Rr4AmWBqUZ++Zb7A+/U8fu+bqHQ7jFhkb2ZaAbYY0XL0CHV0nth3lR1kTY
 8DJ7+guLw7D4rvGB/MeoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just like the other entries

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index dd7a82b..1a65838 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -101,14 +101,14 @@ config TCG_IBMVTPM
 	  as a module, choose M here; the module will be called tpm_ibmvtpm.
 
 config TCG_ST33_I2C
-        tristate "STMicroelectronics ST33 I2C TPM"
-        depends on I2C
-        depends on GPIOLIB
-        ---help---
-        If you have a TPM security chip from STMicroelectronics working with
-        an I2C bus say Yes and it will be accessible from within Linux.
-        To compile this driver as a module, choose M here; the module will be
-        called tpm_stm_st33_i2c.
+	tristate "STMicroelectronics ST33 I2C TPM"
+	depends on I2C
+	depends on GPIOLIB
+	---help---
+	  If you have a TPM security chip from STMicroelectronics working with
+	  an I2C bus say Yes and it will be accessible from within Linux.
+	  To compile this driver as a module, choose M here; the module will be
+	  called tpm_stm_st33_i2c.
 
 config TCG_XEN
 	tristate "XEN TPM Interface"
-- 
1.7.5.4

