Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3J2Duc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:50:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18054 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3J2Dub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:50:31 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] vexpress: remove declaration of vexpress_clk_of_init()
Date: Tue, 29 Oct 2013 11:40:33 +0800
Message-ID: <1383018033-1864-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit:6e973d2c(clk: vexpress: Add separate SP810 driver),
vexpress_clk_of_init() is unnecessary and removed, so kill it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/vexpress.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 617c01b..0e65172 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -122,6 +122,5 @@ struct clk *vexpress_osc_setup(struct device *dev);
 void vexpress_osc_of_setup(struct device_node *node);
 
 void vexpress_clk_init(void __iomem *sp810_base);
-void vexpress_clk_of_init(void);
 
 #endif
-- 
1.8.2.1


