Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3IQDVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:21:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58902 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751749Ab3IQDVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:21:46 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: msalter@redhat.com, a-jacquiot@ti.com
Cc: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] c6x: remove unused parameter in Kconfig
Date: Tue, 17 Sep 2013 05:21:29 +0200
Message-Id: <1379388089-4384-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the TMS320C6X_CACHES_ON kernel configuration
parameter defined in arch/c6x/Kconfig, but used nowhere
in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 957dd00..b4f7725 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -105,10 +105,6 @@ menu "Processor type and features"
 
 source "arch/c6x/platforms/Kconfig"
 
-config TMS320C6X_CACHES_ON
-	bool "L2 cache support"
-	default y
-
 config KERNEL_RAM_BASE_ADDRESS
 	hex "Virtual address of memory base"
 	default 0xe0000000 if SOC_TMS320C6455
-- 
1.8.1.2

