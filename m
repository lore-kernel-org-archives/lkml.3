Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3AVMMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:12:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49681 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3AVMME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:12:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/2] ACPI / PM: Use string "D3cold" to represent ACPI_STATE_D3_COLD
Date: Tue, 22 Jan 2013 13:16:06 +0100
Message-ID: <1491985.dA1TUFB41J@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4115893.XLRCUukpRD@vostro.rjw.lan>
References: <4115893.XLRCUukpRD@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make acpi_power_state_string() return "D3cold" as the string
representation of ACPI power state D3cold instead of "D3" returned
currently, which is confusing.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -115,7 +115,7 @@ const char *acpi_power_state_string(int
 	case ACPI_STATE_D3_HOT:
 		return "D3hot";
 	case ACPI_STATE_D3_COLD:
-		return "D3";
+		return "D3cold";
 	default:
 		return "(unknown)";
 	}

