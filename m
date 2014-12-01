Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaLAK7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:59:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50905 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752795AbaLAK7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:59:34 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] mfd: atmel-hlcdc: Add Kconfig option description and name
Date: Mon,  1 Dec 2014 11:52:36 +0100
Message-Id: <1417431156-4914-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFD_ATMEL_HLCDC was first intended to be selected by its sub-devices
but these sub-devices now depends on this option, we thus need to add
a name and a description so that users can see it.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mfd/Kconfig | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c9200d3..4a637f4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -60,10 +60,15 @@ config MFD_AAT2870_CORE
 	  functionality of the device.
 
 config MFD_ATMEL_HLCDC
-	tristate
+	tristate "Atmel HLCDC (High-end LCD Controller)"
 	select MFD_CORE
 	select REGMAP_MMIO
 	depends on OF
+	help
+	  If you say yes here you get support for the HLCDC block.
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
 
 config MFD_BCM590XX
 	tristate "Broadcom BCM590xx PMUs"
-- 
1.9.1

