Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3GLAHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:07:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38988 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab3GKX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 27/30] ACPI / hotplug / PCI: Get rid of unused constants in acpiphp.h
Date: Fri, 12 Jul 2013 02:05:34 +0200
Message-ID: <4232149.txtv09KINv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Drop some unused symbols from acpiphp.h and redefine SLOT_ENABLED
(which is the only slot flag now) as 1.

[rjw: Redefinition of SLOT_ENABLED, changelog]
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/pci/hotplug/acpiphp.h | 4 ----
 drivers/pci/hotplug/acpiphp.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -152,16 +152,12 @@ struct acpiphp_attention_info
 	struct module *owner;
 };
 
-/* PCI bus bridge HID */
-#define ACPI_PCI_HOST_HID		"PNP0A03"
-
 /* ACPI _STA method value (ignore bit 4; battery present) */
 #define ACPI_STA_ALL			(0x0000000f)
 
 /* slot flags */
 
-#define SLOT_ENABLED		(0x00000002)
-#define SLOT_MULTIFUNCTION	(0x00000004)
+#define SLOT_ENABLED		(0x00000001)
 
 /* function flags */
 

