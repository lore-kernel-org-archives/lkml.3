Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3AMOSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 09:18:50 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:36563 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3AMOSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 09:18:49 -0500
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH] ACPI: remove unused acpi_op_bind and acpi_op_unbind
Date: Sun, 13 Jan 2013 22:16:42 +0800
Message-Id: <1358086602-32538-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <2326457.ZgAhayTgyl@vostro.rjw.lan>
References: <2326457.ZgAhayTgyl@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With commit f2a33cde55a03 "ACPI: Drop ACPI device .bind() and .unbind()
callbacks", acpi_op_bind and acpi_op_unbind are not used any more. So
remove them.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 include/acpi/acpi_bus.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 6e9a73e..ef539eb 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -91,8 +91,6 @@ struct acpi_device;
 typedef int (*acpi_op_add) (struct acpi_device * device);
 typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
 typedef int (*acpi_op_start) (struct acpi_device * device);
-typedef int (*acpi_op_bind) (struct acpi_device * device);
-typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
 
 struct acpi_device_ops {
-- 
1.7.9.5

