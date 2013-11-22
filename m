Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3KVB5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:57:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3KVB5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:57:39 -0500
From: Joel Fernandes <joelf@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <benoit.cousson@linaro.org>, <santosh.shilimkar@ti.com>,
        <jgchunter@gmail.com>, <rnayak@ti.com>, <balbi@ti.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 3/8] rc: ir-rx51: Turn ON ir-rx51 as it should work for MULTIPLATFORM
Date: Thu, 21 Nov 2013 19:56:49 -0600
Message-ID: <1385085414-9034-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385085414-9034-1-git-send-email-joelf@ti.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patches moved public portion of dmtimer declaration out into
include/linux/. With this, ir-rx51 compiles fine with CONFIG_ARCH_MULTIPLATFORM

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/media/rc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 11e84bc..36997b6 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -292,7 +292,7 @@ config IR_TTUSBIR
 
 config IR_RX51
 	tristate "Nokia N900 IR transmitter diode"
-	depends on OMAP_DM_TIMER && ARCH_OMAP2PLUS && LIRC && !ARCH_MULTIPLATFORM
+	depends on OMAP_DM_TIMER && ARCH_OMAP2PLUS && LIRC
 	---help---
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
-- 
1.8.1.2

