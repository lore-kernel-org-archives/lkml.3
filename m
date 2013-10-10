Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3JJL2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:28:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59427 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab3JJL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:28:03 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@gmail.com>, <tglx@linutronix.de>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 1/2] irqchip: mmp: avoid use head file in a specific arch
Date: Thu, 10 Oct 2013 19:27:54 +0800
Message-ID: <1381404475-25843-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-10_04:2013-10-10,2013-10-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310100028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example, arm64 doesn't have mach/irq.h.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
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

