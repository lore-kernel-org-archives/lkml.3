Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbaFUKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:16:27 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:34520 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaFUKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:16:25 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH] thunderbolt: select CRC32 in Kconfig
Date: Sat, 21 Jun 2014 12:15:44 +0200
Message-Id: <1403345744-15497-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use __crc32c_le in ctl.c. So make sure that the dependency is there.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index 5aab79b..c121acc 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,6 +1,7 @@
 menuconfig THUNDERBOLT
 	tristate "Thunderbolt support for Apple devices"
 	depends on PCI
+	select CRC32
 	help
 	  Cactus Ridge Thunderbolt Controller driver
 	  This driver is required if you want to hotplug Thunderbolt devices on
-- 
2.0.0

