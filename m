Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBRSXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:23:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaBRSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:22:54 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        devel@acpica.org, mingo@redhat.com, ck@conrad-kostecki.de,
        tglx@linutronix.de, trenn@suse.de, rjw@rjwysocki.net
Subject: [PATCH 3/4] ACPICA: Add BGRT signature to known signatures
Date: Tue, 18 Feb 2014 19:22:42 +0100
Message-Id: <1392747763-3384-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1392747763-3384-1-git-send-email-trenn@suse.de>
References: <530265A3.3020302@zytor.com>
 <1392747763-3384-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux there even exists a driver already making use of this table:
drivers/acpi/bgrt.c:MODULE_DESCRIPTION("BGRT boot graphic support");

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
 include/acpi/actbl2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 094a906..9ed1c20 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -83,6 +83,7 @@
 #define ACPI_SIG_WDAT           "WDAT"	/* Watchdog Action Table */
 #define ACPI_SIG_WDDT           "WDDT"	/* Watchdog Timer Description Table */
 #define ACPI_SIG_WDRT           "WDRT"	/* Watchdog Resource Table */
+#define ACPI_SIG_BGRT           "BGRT"  /* Boot Graphic Support */
 
 #ifdef ACPI_UNDEFINED_TABLES
 /*
-- 
1.7.6.1

