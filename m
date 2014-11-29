Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaK2Sbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:31:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50202 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaK2Sbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:31:46 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH] drivers: kconfig: fix double include
Date: Sat, 29 Nov 2014 19:31:36 +0100
Message-Id: <1417285896-8587-1-git-send-email-s.trumtrar@pengutronix.de>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/Kconfig sources drivers/soc/Kconfig twice.
Remove the last include.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 694d5a70d6ce..2683e633c027 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -150,8 +150,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/devfreq/Kconfig"
 
 source "drivers/extcon/Kconfig"
-- 
2.1.3

