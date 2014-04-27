Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaD0Vfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:35:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaD0Vfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:35:44 -0400
Message-ID: <535D782F.3020801@suse.com>
Date: Sun, 27 Apr 2014 17:35:43 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] s390: add slab.h for kzalloc/kfree
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:
arch/s390/appldata/appldata_mem.c:135:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
arch/s390/appldata/appldata_mem.c:141:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 arch/s390/appldata/appldata_mem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/appldata/appldata_mem.c
+++ b/arch/s390/appldata/appldata_mem.c
@@ -13,6 +13,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 
 #include "appldata.h"

-- 
Jeff Mahoney
SUSE Labs
