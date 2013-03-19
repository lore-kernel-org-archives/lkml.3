Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab3CSV1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:27:37 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:55225 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964890Ab3CSV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:27:34 -0400
Message-ID: <1363728449.1390.38.camel@x61.thuisdomein>
Subject: [PATCH] ARM: remove unused "config XSCALE_PMU"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 22:27:29 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 21:27:29.0627 (UTC) FILETIME=[8F5862B0:01CE24E8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reference to Kconfig symbol XSCALE_PMU got removed in v3.7,
with commit f0d1bc47953743aef9d2ed5326bc5973a3db08ab ("ARM: pmu: remove
unused reservation mechanism"). We can remove the Kconfig entry for
this unused symbol now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3bdce..0ff7081 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1189,11 +1189,6 @@ config IWMMXT
 	  Enable support for iWMMXt context switching at run time if
 	  running on a CPU that supports it.
 
-config XSCALE_PMU
-	bool
-	depends on CPU_XSCALE
-	default y
-
 config MULTI_IRQ_HANDLER
 	bool
 	help
-- 
1.7.11.7

