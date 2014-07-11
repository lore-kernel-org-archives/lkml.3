Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaGKXrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:47:53 -0400
Received: from lhrrgout.huawei.com ([194.213.3.17]:58631 "EHLO
	lhrrgout.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGKXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:47:52 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>, <nicolas.pitre@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <ebiederm@xmission.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <liuxueliu.liu@huawei.com>,
        <peifeiyue@huawei.com>, <liusdu@huawei.com>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [RFC PATCH 1/2] irqchip: GIC: introduce ICPIDR2 register interface
Date: Fri, 11 Jul 2014 14:46:16 +0800
Message-ID: <1405061177-43834-2-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
References: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peripheral ID2 Register provides a four-bit architecturally-defined
architecture revision field. So we can identify the GIC verison from
this register. It is useful sometimes.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 include/linux/irqchip/arm-gic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 45e2d8c..872a562 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -38,6 +38,7 @@
 #define GIC_DIST_SOFTINT		0xf00
 #define GIC_DIST_SGI_PENDING_CLEAR	0xf10
 #define GIC_DIST_SGI_PENDING_SET	0xf20
+#define GIC_DIST_ICPIDR2		0xfe8
 
 #define GICH_HCR			0x0
 #define GICH_VTR			0x4
-- 
1.9.0

