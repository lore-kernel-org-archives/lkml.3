Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaB1RYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:24:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaB1RYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:24:07 -0500
From: Thomas Renninger <trenn@suse.de>
To: robert.moore@intel.com, lv.zheng@intel.com, david.e.box@intel.com,
        rafael.j.wysocki@intel.com
Cc: Thomas Renninger <trenn@suse.de>, hpa@zytor.com, tglx@linutronix.de,
        ck@conrad-kostecki.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        mingo@redhat.com, rjw@rjwysocki.net, devel@acpica.org
Subject: [PATCH 3/4] ACPICA: Add BGRT signature to known signatures
Date: Fri, 28 Feb 2014 18:24:00 +0100
Message-Id: <1393608241-31037-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1393608241-31037-1-git-send-email-trenn@suse.de>
References: <1393608241-31037-1-git-send-email-trenn@suse.de>
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

