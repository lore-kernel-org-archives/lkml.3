Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaIZGRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:17:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21227 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbaIZGRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:17:47 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <sebastian.hesselbarth@gmail.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] ARM: berlin: sort Kconfig options
Date: Fri, 26 Sep 2014 14:14:57 +0800
Message-ID: <1411712097-700-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-26_04:2014-09-26,2014-09-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409260068
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep options alphabetically sorted.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 arch/arm/mach-berlin/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index 5803f77..84d34e0 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -3,9 +3,9 @@ menuconfig ARCH_BERLIN
 	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_GIC
-	select GENERIC_IRQ_CHIP
 	select DW_APB_ICTL
 	select DW_APB_TIMER_OF
+	select GENERIC_IRQ_CHIP
 	select PINCTRL
 	select RESET_CONTROLLER
 
-- 
2.1.1

