Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaBRSW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:22:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaBRSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:22:54 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        devel@acpica.org, mingo@redhat.com, ck@conrad-kostecki.de,
        tglx@linutronix.de, trenn@suse.de, rjw@rjwysocki.net
Subject: [PATCH 4/4] ACPI: Add new table signatures that can be overridden/added.
Date: Tue, 18 Feb 2014 19:22:43 +0100
Message-Id: <1392747763-3384-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1392747763-3384-1-git-send-email-trenn@suse.de>
References: <530265A3.3020302@zytor.com>
 <1392747763-3384-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: hpa@zytor.com
CC: tglx@linutronix.de
CC: ck@conrad-kostecki.de
CC: linux-kernel@vger.kernel.org
CC: x86@kernel.org
CC: mingo@redhat.com
CC: rjw@rjwysocki.net
CC: devel@acpica.org
---
 drivers/acpi/osl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 07439b4..deba2f0 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/nmi.h>
+# define ACPI_UNDEFINED_TABLES 1
 #include <linux/acpi.h>
 #include <linux/efi.h>
 #include <linux/ioport.h>
@@ -559,7 +560,8 @@ static const char * const table_sigs[] = {
 	ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
 	ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
 	ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
-	ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
+	ACPI_SIG_WDRT, ACPI_SIG_BGRT, ACPI_SIG_ATKG, ACPI_SIG_GSCI,
+	ACPI_SIG_IEIT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
 	ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
 
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
-- 
1.7.6.1

