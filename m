Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab3LMFEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:04:31 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:42987 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3LMFE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:04:29 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Quyaxin <quyaxin@hisilicon.com>
Subject: [PATCH] mtd: increase max page/OOB size to support 16K pagesize NAND
Thread-Topic: [PATCH] mtd: increase max page/OOB size to support 16K
 pagesize NAND
Thread-Index: Ac73wHFUVxllXJ0gQ5W2mMUVtZIWEQ==
Date: Fri, 13 Dec 2013 05:01:56 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E47448@SZXEMA512-MBX.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>
Date: Fri, 13 Dec 2013 12:52:46 +0800
Subject: [PATCH] mtd: increase max page/OOB size to support 16K pagesize NAND.

The Toshiba's TC58TEG5DCJTA pagesize is 16K, oob size is 1280 bytes.
So increase the NAND_MAX_OOBSIZE and NAND_MAX_PAGESIZE.

Signed-off-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
---
 include/linux/mtd/nand.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index f3ea8da..2f0a7f2 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -56,8 +56,8 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
  * is supported now. If you add a chip with bigger oobsize/page
  * adjust this accordingly.
  */
-#define NAND_MAX_OOBSIZE	744
-#define NAND_MAX_PAGESIZE	8192
+#define NAND_MAX_OOBSIZE	1280
+#define NAND_MAX_PAGESIZE	16384
 
 /*
  * Constants for hardware specific CLE/ALE/NCE function
