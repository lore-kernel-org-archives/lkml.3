Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3HaBpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 21:45:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3207 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3HaBpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 21:45:22 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] irq/of: Fix comment typo for irq_of_parse_and_map
Date: Sat, 31 Aug 2013 09:44:10 +0800
Message-ID: <1377913450-30108-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial comment typo for irq_of_parse_and_map().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/of/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 1264923..1752988 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -28,7 +28,7 @@
 
 /**
  * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
- * @device: Device node of the device whose interrupt is to be mapped
+ * @dev: Device node of the device whose interrupt is to be mapped
  * @index: Index of the interrupt to map
  *
  * This function is a wrapper that chains of_irq_map_one() and
-- 
1.7.1


