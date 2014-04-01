Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaDAQPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:15:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaDAQPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 73/86] i2c: Remove usage of orphaned symbol OF_I2C
Date: Tue,  1 Apr 2014 09:08:26 -0700
Message-Id: <1396368519-12728-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 62c19c9d29e65086e5ae76df371ed2e6b23f00cd upstream.

The symbol is an orphan, don't depend on it anymore.

Signed-off-by: Richard Weinberger <richard@nod.at>
[wsa: enhanced commit message]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Fixes: 687b81d083c0 (i2c: move OF helpers into the core)
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 699f9da..7dbdfca 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -350,7 +350,7 @@ config I2C_CBUS_GPIO
 
 config I2C_CPM
 	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
-	depends on (CPM1 || CPM2) && OF_I2C
+	depends on CPM1 || CPM2
 	help
 	  This supports the use of the I2C interface on Freescale
 	  processors with CPM1 or CPM2.
-- 
1.8.3.2

