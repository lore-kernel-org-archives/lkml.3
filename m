Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3LFKq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:46:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48867 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207Ab3LFKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:46:55 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <tglx@linutronix.de>, <haojian.zhuang@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH v3] irqchip: mmp: avoid use head file in a specific arch
Date: Fri, 6 Dec 2013 18:46:47 +0800
Message-ID: <1386326807-21688-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-06_03:2013-12-06,2013-12-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312060023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example, arm64 doesn't have mach/irq.h.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/irqchip/irq-mmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 2cb7cd0..470c5de 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -22,7 +22,7 @@
 #include <linux/of_irq.h>
 
 #include <asm/exception.h>
-#include <asm/mach/irq.h>
+#include <asm/hardirq.h>
 
 #include "irqchip.h"
 
-- 
1.7.9.5

