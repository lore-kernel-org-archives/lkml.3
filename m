Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaDALls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:41:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaDALSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>, Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 100/144] i2c: Remove usage of orphaned symbol OF_I2C
Date: Tue,  1 Apr 2014 12:15:04 +0100
Message-Id: <1396350948-29910-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 62c19c9d29e65086e5ae76df371ed2e6b23f00cd upstream.

The symbol is an orphan, don't depend on it anymore.

Signed-off-by: Richard Weinberger <richard@nod.at>
[wsa: enhanced commit message]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Fixes: 687b81d083c0 (i2c: move OF helpers into the core)
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index dc6dea6..556a42b 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -375,7 +375,7 @@ config I2C_CBUS_GPIO
 
 config I2C_CPM
 	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
-	depends on (CPM1 || CPM2) && OF_I2C
+	depends on CPM1 || CPM2
 	help
 	  This supports the use of the I2C interface on Freescale
 	  processors with CPM1 or CPM2.
-- 
1.9.1

