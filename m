Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3CTNeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:34:06 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55633 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab3CTNeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:34:05 -0400
Message-ID: <1363786439.1390.98.camel@x61.thuisdomein>
Subject: [PATCH] C6X: remove "config COMMON_CLKDEV"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 14:33:59 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 13:33:59.0222 (UTC) FILETIME=[93D65D60:01CE256F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since C6X was added to the tree in v3.3 it has had an entry for
COMMON_CLKDEV in its main Kconfig file. But at that time nothing in the
tree used COMMON_CLKDEV anymore. That functionality is now available
through selecting CLKDEV_LOOKUP. And that is what this Kconfig file also
does. Anyhow, this Kconfig entry can be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

 arch/c6x/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index f6a3648..ecee897 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -37,9 +37,6 @@ config GENERIC_HWEIGHT
 config GENERIC_BUG
 	def_bool y
 
-config COMMON_CLKDEV
-	def_bool y
-
 config C6X_BIG_KERNEL
 	bool "Build a big kernel"
 	help
-- 
1.7.11.7

