Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaAUVZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:56476 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaAUVZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 39/73] powerpc: delete another unrequired instance of <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:42 -0500
Message-ID: <1390339396-3479-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most were already deleted in the 1st pass audit; this instance
showed up more recently.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/sysdev/indirect_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/sysdev/indirect_pci.c b/arch/powerpc/sysdev/indirect_pci.c
index 1f6c570..66f5fd1 100644
--- a/arch/powerpc/sysdev/indirect_pci.c
+++ b/arch/powerpc/sysdev/indirect_pci.c
@@ -13,7 +13,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/string.h>
-#include <linux/init.h>
 
 #include <asm/io.h>
 #include <asm/prom.h>
-- 
1.8.4.1

