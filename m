Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab3ANVeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:34:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40748 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758174Ab3ANVdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:33:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: [PATCH 1/5] ACPI: Remove the ops field from struct acpi_device
Date: Mon, 14 Jan 2013 22:37:28 +0100
Message-ID: <4366378.jvoXLv5QGr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3885603.ydrrB7OEKf@vostro.rjw.lan>
References: <3885603.ydrrB7OEKf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ops field in struct acpi_device is not used anywhere, so remove
it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/acpi/acpi_bus.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -271,7 +271,6 @@ struct acpi_device {
 	struct acpi_device_wakeup wakeup;
 	struct acpi_device_perf performance;
 	struct acpi_device_dir dir;
-	struct acpi_device_ops ops;
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;
