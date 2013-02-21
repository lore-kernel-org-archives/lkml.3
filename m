Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3BUTEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:04:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:21173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3BUTEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:04:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="288928224"
Subject: [PATCH] Update the links to the white papers on CRC32C
 calculations with PCLMULQDQ instructions.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>,
        James Guilford <james.guilford@intel.com>,
        David Cote <david.m.cote@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Feb 2013 11:04:22 -0800
Message-ID: <1361473462.17632.202.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

The following patch update the stale link to the CRC32C white paper 
that was referenced.

Tim


Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 93c6d39..f3f1e42 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -1,9 +1,10 @@
 /*
  * Implement fast CRC32C with PCLMULQDQ instructions. (x86_64)
  *
- * The white paper on CRC32C calculations with PCLMULQDQ instruction can be
+ * The white papers on CRC32C calculations with PCLMULQDQ instruction can be
  * downloaded from:
- * http://download.intel.com/design/intarch/papers/323405.pdf
+ * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/crc-iscsi-polynomial-crc32-instruction-paper.pdf
+ * http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-crc-computation-paper.pdf
  *
  * Copyright (C) 2012 Intel Corporation.
  *
-- 
1.7.6.5


