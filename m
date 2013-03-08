Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3CHT20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:28:26 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:28000 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3CHT2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:28:25 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Remove acpi_pci_bind_root() definition
Date: Fri,  8 Mar 2013 12:17:10 -0700
Message-Id: <1362770230-8734-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed that acpi_pci_bind_root(), which has been deleted,
is left defined in acpi_driver.h.  So delete this definition
from the header as well.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 include/acpi/acpi_drivers.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 627749a..e6168a2 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -95,7 +95,6 @@ int acpi_pci_link_free_irq(acpi_handle handle);
 struct pci_bus;
 
 struct pci_dev *acpi_get_pci_dev(acpi_handle);
-int acpi_pci_bind_root(struct acpi_device *device);
 
 /* Arch-defined function to add a bus to the system */
 
