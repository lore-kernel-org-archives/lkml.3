Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3HFAWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:22:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57234 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab3HFAVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:21:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3/5] ACPI: acpi_bind_one()/acpi_unbind_one() whitespace cleanups
Date: Tue, 06 Aug 2013 02:27:24 +0200
Message-ID: <1410756.IOZGpZQa04@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3015032.qfOqgEVZKP@vostro.rjw.lan>
References: <3015032.qfOqgEVZKP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Clean up some inconsistent use of whitespace in acpi_bind_one() and
acpi_unbind_one().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -182,9 +182,9 @@ int acpi_bind_one(struct device *dev, ac
 
 	acpi_bind_physnode_name(physical_node_name, node_id);
 	retval = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
-			physical_node_name);
+				   physical_node_name);
 	retval = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
-		"firmware_node");
+				   "firmware_node");
 
 	mutex_unlock(&acpi_dev->physical_node_lock);
 
@@ -228,12 +228,11 @@ int acpi_unbind_one(struct device *dev)
 		char physical_node_name[PHYSICAL_NODE_NAME_SIZE];
 
 		entry = list_entry(node, struct acpi_device_physical_node,
-			node);
+				   node);
 		if (entry->dev != dev)
 			continue;
 
 		list_del(node);
-
 		acpi_dev->physical_node_count--;
 
 		acpi_bind_physnode_name(physical_node_name, entry->node_id);

