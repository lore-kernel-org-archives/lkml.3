Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947327Ab3BHXLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:11:42 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35536 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947176Ab3BHXLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:11:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH] ACPI: Drop the container.h header file
Date: Sat, 09 Feb 2013 00:18:01 +0100
Message-ID: <1845543.1spGohx2XC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1435179.fU91E9qMVO@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1891536.LKCrpu1upY@vostro.rjw.lan> <1435179.fU91E9qMVO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The include/acpi/container.h only contains a definition of a
structure that is not used any more, so drop it entirely.

Similar change was proposed earlier by Toshi Kani.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of current linux-pm.git/bleeding-edge.

Thanks,
Rafael

---
 drivers/acpi/container.c |    1 -
 include/acpi/container.h |   12 ------------
 2 files changed, 13 deletions(-)

Index: test/include/acpi/container.h
===================================================================
--- test.orig/include/acpi/container.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __ACPI_CONTAINER_H
-#define __ACPI_CONTAINER_H
-
-#include <linux/kernel.h>
-
-struct acpi_container {
-	acpi_handle handle;
-	unsigned long sun;
-	int state;
-};
-
-#endif				/* __ACPI_CONTAINER_H */
Index: test/drivers/acpi/container.c
===================================================================
--- test.orig/drivers/acpi/container.c
+++ test/drivers/acpi/container.c
@@ -34,7 +34,6 @@
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
-#include <acpi/container.h>
 
 #define PREFIX "ACPI: "
 

