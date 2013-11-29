Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab3K2Pde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:33:34 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36391 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3K2Pdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:33:32 -0500
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -rc1] s390: increase the NR_CPUS limit
Date: Fri, 29 Nov 2013 16:33:02 +0100
Message-Id: <1385739182-3687-1-git-send-email-xose.vazquez@gmail.com>
X-Mailer: git-send-email 1.8.3.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current models, maximum number of active cores is 101.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <linux390@de.ibm.com>
Cc: <linux-s390@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 arch/s390/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 314fced..87afb9a 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -347,14 +347,14 @@ config SMP
 	  Even if you don't know what to do here, say Y.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-64)"
-	range 2 64
+	int "Maximum number of CPUs (2-101)"
+	range 2 101
 	depends on SMP
 	default "32" if !64BIT
 	default "64" if 64BIT
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 64 and the
+	  kernel will support.  The maximum supported value is 101 and the
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
-- 
1.8.3.1

