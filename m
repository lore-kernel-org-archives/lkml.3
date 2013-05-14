Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3ENCRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:17:52 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57890 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3ENCRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:17:04 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        michael@ellerman.id.au, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 5/5] powerpc: select HAVE_CONTEXT_TRACKING for pSeries
Date: Tue, 14 May 2013 10:16:44 +0800
Message-Id: <1368497804-21706-6-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051402-3864-0000-0000-0000082181F5
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

