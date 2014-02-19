Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBSBSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:18:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52119 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392AbaBSBS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 9/9] ACPI / dock: Update copyright notice
Date: Wed, 19 Feb 2014 02:32:50 +0100
Message-ID: <2585039.uxTQ3ZVMg2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Update the copyright notice of the ACPI dock driver to reflect the
fact that substantial changes have been made to it recently.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -1,7 +1,9 @@
 /*
  *  dock.c - ACPI dock station driver
  *
- *  Copyright (C) 2006 Kristen Carlson Accardi <kristen.c.accardi@intel.com>
+ *  Copyright (C) 2006, 2014, Intel Corp.
+ *  Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
+ *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *

