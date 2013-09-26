Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3IZS5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:57:45 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:45856 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IZSvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:15 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 02/21] of: remove unnecessary prom.h includes
Date: Thu, 26 Sep 2013 13:50:37 -0500
Message-Id: <1380221456-11192-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove unnecessary prom.h includes in preparation to make prom.h optional.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/of/of_pci_irq.c | 1 -
 drivers/of/pdt.c        | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/of/of_pci_irq.c b/drivers/of/of_pci_irq.c
index 6770538..d860764 100644
--- a/drivers/of/of_pci_irq.c
+++ b/drivers/of/of_pci_irq.c
@@ -2,7 +2,6 @@
 #include <linux/of_pci.h>
 #include <linux/of_irq.h>
 #include <linux/export.h>
-#include <asm/prom.h>
 
 /**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 4ec19cb..7b66673 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_pdt.h>
-#include <asm/prom.h>
 
 static struct of_pdt_ops *of_pdt_prom_ops __initdata;
 
-- 
1.8.1.2

