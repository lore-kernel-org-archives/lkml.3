Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3LQJ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:28:49 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41422 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3LQJ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:28:41 -0500
Date: Tue, 17 Dec 2013 14:58:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 07/11] drivers: acpi: Include appropriate header file in
 pci_link.c
Message-ID: <a8a439a6a00b03ab0df484dc157155034126736b.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes appropriate header file internal.h in pci_link.c
because function acpi_pci_link_init() has its prototype declaration in
internal.h.

This eliminates the following warning in pci_link.c:
drivers/acpi/pci_link.c:874:13: warning: no previous prototype for ‘acpi_pci_link_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/pci_link.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 2652a61..447c329 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -42,6 +42,7 @@
 
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include "internal.h"
 
 #define PREFIX "ACPI: "
 
-- 
1.7.9.5

