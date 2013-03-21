Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3CUJp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:45:56 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:61278 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758267Ab3CUJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:45:54 -0400
Message-ID: <1363859137.1390.106.camel@x61.thuisdomein>
Subject: [PATCH] C6X: remove "config TMS320C6X_CACHES_ON"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 10:45:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 09:45:47.0960 (UTC) FILETIME=[DD9F5380:01CE2618]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for TMS320C6X_CACHES_ON was added together with the
C6X build infrastructure in v3.3. It has never been used. It can safely
be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/c6x/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index ecee897..7569e9b 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -103,10 +103,6 @@ menu "Processor type and features"
 
 source "arch/c6x/platforms/Kconfig"
 
-config TMS320C6X_CACHES_ON
-	bool "L2 cache support"
-	default y
-
 config KERNEL_RAM_BASE_ADDRESS
 	hex "Virtual address of memory base"
 	default 0xe0000000 if SOC_TMS320C6455
-- 
1.7.11.7

