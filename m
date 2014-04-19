Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaDSAPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59461 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaDSAOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:44 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 6/8] pci-driver: added or removed a space to resolve checkpatch messages
Date: Fri, 18 Apr 2014 20:13:51 -0400
Message-Id: <1397866433-21119-7-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes made to resolve following messages:
  ERROR: spaces required around that '=' (ctx:VxV)
  ERROR: "foo * bar" should be "foo *bar"
  ERROR: spaces required around that '<=' (ctx:VxV)
  ERROR: space required before the open parenthesis '('
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci-driver.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d911e0c..821efe2 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -103,10 +103,10 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
 {
 	struct pci_driver *pdrv = to_pci_driver(driver);
 	const struct pci_device_id *ids = pdrv->id_table;
-	__u32 vendor, device, subvendor=PCI_ANY_ID,
-		subdevice=PCI_ANY_ID, class=0, class_mask=0;
-	unsigned long driver_data=0;
-	int fields=0;
+	__u32 vendor, device, subvendor = PCI_ANY_ID,
+		subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
+	unsigned long driver_data = 0;
+	int fields = 0;
 	int retval;
 
 	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
@@ -351,7 +351,7 @@ __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 	return error;
 }
 
-static int pci_device_probe(struct device * dev)
+static int pci_device_probe(struct device *dev)
 {
 	int error = 0;
 	struct pci_driver *drv;
@@ -367,10 +367,10 @@ static int pci_device_probe(struct device * dev)
 	return error;
 }
 
-static int pci_device_remove(struct device * dev)
+static int pci_device_remove(struct device *dev)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 
 	if (drv) {
 		if (drv->remove) {
@@ -498,8 +498,8 @@ static int pci_pm_reenable_device(struct pci_dev *pci_dev)
 
 static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 
 	if (drv && drv->suspend) {
 		pci_power_t prev = pci_dev->current_state;
@@ -525,8 +525,8 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 
 static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 
 	if (drv && drv->suspend_late) {
 		pci_power_t prev = pci_dev->current_state;
@@ -556,8 +556,8 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 
 static int pci_legacy_resume_early(struct device *dev)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 
 	return drv && drv->resume_early ?
 			drv->resume_early(pci_dev) : 0;
@@ -565,8 +565,8 @@ static int pci_legacy_resume_early(struct device *dev)
 
 static int pci_legacy_resume(struct device *dev)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
@@ -1252,7 +1252,7 @@ pci_dev_driver(const struct pci_dev *dev)
 		return dev->driver;
 	else {
 		int i;
-		for(i=0; i<=PCI_ROM_RESOURCE; i++)
+		for (i = 0; i <= PCI_ROM_RESOURCE; i++)
 			if (dev->resource[i].flags & IORESOURCE_BUSY)
 				return &pci_compat_driver;
 	}
-- 
1.9.1

