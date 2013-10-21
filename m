Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3JUXyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:54:11 -0400
Received: from mout.gmx.net ([212.227.15.15]:56243 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab3JUXyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:54:09 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/2] tpm: use tabs instead of whitespaces in Kconfig
Date: Tue, 22 Oct 2013 01:53:48 +0200
Message-Id: <1382399628-28409-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382399628-28409-1-git-send-email-peterhuewe@gmx.de>
References: <1382399628-28409-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:LfwxdqF0s8nU7QF1C+CX6rrUSl2aYXY3kLvkZPjXf+sdXt0KlRM
 nf8GPzQCEKd0xEJzdse/xIVerrvj0aC9Nlea1x97a4nd8kuuNVzpbIhSn4+1qgav+Dy8My5
 yBoRJz/Pu2PTXs4+9+jXXhlXc5dptRCa34I418XDkG4RE/1SPLHHVjG/QOWwipzGqnKQ3ys
 tW0u7jp9t5eCmj9+GUl6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just like the other entries

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 4716af5..4dd4363 100644
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
-        called tpm_i2c_stm_st33.
+	tristate "STMicroelectronics ST33 I2C TPM"
+	depends on I2C
+	depends on GPIOLIB
+	---help---
+	  If you have a TPM security chip from STMicroelectronics working with
+	  an I2C bus say Yes and it will be accessible from within Linux.
+	  To compile this driver as a module, choose M here; the module will be
+	  called tpm_i2c_stm_st33.
 
 config TCG_XEN
 	tristate "XEN TPM Interface"
-- 
1.7.5.4

