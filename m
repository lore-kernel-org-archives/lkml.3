Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3C2KBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:01:39 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:57974 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3C2KBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:01:04 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 5/6] powerpc: select HAVE_CONTEXT_TRACKING for pSeries
Date: Fri, 29 Mar 2013 18:00:20 +0800
Message-Id: <1364551221-23177-6-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032909-2674-0000-0000-000008677EC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start context tracking support from pSeries.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 9a0941b..023b288 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -18,6 +18,7 @@ config PPC_PSERIES
 	select PPC_PCI_CHOICE if EXPERT
 	select ZLIB_DEFLATE
 	select PPC_DOORBELL
+	select HAVE_CONTEXT_TRACKING
 	default y
 
 config PPC_SPLPAR
-- 
1.7.9.5

