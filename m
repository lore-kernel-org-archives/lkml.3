Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3ARMaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:30:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:44844 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab3ARMar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:30:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / PM: Remove obsolete comment in power.c
Date: Fri, 18 Jan 2013 13:36:44 +0100
Message-ID: <1750752.GpUDbSLOP5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The TBD comment in power.c saying that power resources must be
ordered is obsolete, because power resources acually are ordered now,
so remove it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/power.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -645,8 +645,6 @@ int acpi_power_transition(struct acpi_de
 	    || (device->power.state > ACPI_STATE_D3_COLD))
 		return -ENODEV;
 
-	/* TBD: Resources must be ordered. */
-
 	/*
 	 * First we reference all power resources required in the target list
 	 * (e.g. so the device doesn't lose power while transitioning).  Then,

