Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3JVSB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:01:58 -0400
Received: from mout.gmx.net ([212.227.15.15]:54110 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab3JVSB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:01:29 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 14/15] tpm: Fix module name description in Kconfig for tpm_i2c_infineon
Date: Tue, 22 Oct 2013 20:00:39 +0200
Message-Id: <1382464840-7639-14-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
References: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:5b3mi+AUzpJj4ioDuRXWJEMi+utm6KwMWriDk5S9g1LphBtPJra
 nw36pe8RKgpSGy1ES2X3/4l4GhZqkTNJWmpmIzfc0mheEX9n/d6A1/LFkanG9LJhjXfNd72
 JnqwrXD4IFanMD5Nx+lY49DDZp3cknOLva1ZBX11/8dTjGFgs3SRH7J4uSz8KDrqH0AW2b5
 j8vPjPQSJTiBMONFhc9Ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the displayed module name from
tpm_tis_i2c_infineon to its actual name tpm_i2c_infineon.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f908586..dd7a82b 100644
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
-- 
1.7.5.4

