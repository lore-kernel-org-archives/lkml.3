Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaJHKru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:47:50 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39821 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaJHKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:47:48 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] mm/numa balancing: Rearrange Kconfig entry
Date: Wed,  8 Oct 2014 16:17:28 +0530
Message-Id: <1412765248-31614-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100810-7014-0000-0000-0000004C1D6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the default enable config option after the NUMA_BALANCING option
so that it appears related in the nconfig interface.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 init/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5a5613ed49bc..d73c934f9e77 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -889,14 +889,6 @@ config ARCH_SUPPORTS_INT128
 config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	bool
 
-config NUMA_BALANCING_DEFAULT_ENABLED
-	bool "Automatically enable NUMA aware memory/task placement"
-	default y
-	depends on NUMA_BALANCING
-	help
-	  If set, automatic NUMA balancing will be enabled if running on a NUMA
-	  machine.
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
@@ -909,6 +901,14 @@ config NUMA_BALANCING
 
 	  This system will be inactive on UMA systems.
 
+config NUMA_BALANCING_DEFAULT_ENABLED
+	bool "Automatically enable NUMA aware memory/task placement"
+	default y
+	depends on NUMA_BALANCING
+	help
+	  If set, automatic NUMA balancing will be enabled if running on a NUMA
+	  machine.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	select KERNFS
-- 
1.9.1

