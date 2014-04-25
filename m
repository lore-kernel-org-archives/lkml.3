Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaDYTxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:53:23 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44595 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaDYTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:53:21 -0400
From: jon@ringle.org
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: gregkh@linuxfoundation.org, shc_work@mail.ru,
        Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH 1/2] serial: sc16is7xx: depend on I2C
Date: Fri, 25 Apr 2014 15:53:09 -0400
Message-Id: <1398455590-4374-1-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 drivers/tty/serial/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index c3e2b32..64c5659 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1180,6 +1180,7 @@ config SERIAL_SCCNXP_CONSOLE
 
 config SERIAL_SC16IS7XX
 	tristate "SC16IS7xx serial support"
+	depends on I2C
 	select SERIAL_CORE
 	select REGMAP_I2C if I2C
 	help
-- 
1.8.5.4

