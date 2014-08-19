Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaHSPQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:16:35 -0400
Received: from sauhun.de ([89.238.76.85]:38411 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbaHSPQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:16:33 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] MAINTAINERS: add maintainer for ACPI parts of I2C
Date: Tue, 19 Aug 2014 10:16:21 -0500
Message-Id: <1408461381-18463-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika has done great work in that field, so let people know.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

Mika: What do you think? Your help is very valuable and I'd like to make that
official :)

 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa94841ff3..edba18ce39bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4446,6 +4446,13 @@ F:	include/linux/i2c-*.h
 F:	include/uapi/linux/i2c.h
 F:	include/uapi/linux/i2c-*.h
 
+I2C ACPI SUPPORT
+M:	Mika Westerberg <mika.westerberg@linux.intel.com>
+L:	linux-i2c@vger.kernel.org
+L:	linux-acpi@vger.kernel.org
+S:	Maintained
+F:	drivers/i2c/i2c-acpi.c
+
 I2C-TAOS-EVM DRIVER
 M:	Jean Delvare <jdelvare@suse.de>
 L:	linux-i2c@vger.kernel.org
-- 
2.0.0

