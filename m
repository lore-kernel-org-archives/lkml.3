Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab3IECmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:42:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34453 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762447Ab3IECmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:42:18 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-23-5227ef88cde9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
In-reply-to: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
Subject: [PATCH 3/6] backlight: ld9040: Staticize local variable gamma_table
Date: Thu, 05 Sep 2013 11:42:16 +0900
Message-id: <002401cea9e1$88a4f1d0$99eed570$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIowAAEVgA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ92O9+pBBteP6VvMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tigum5TUnMyy1CJ9uwSujAmT5zMVLGavWPDsBEsD4wy2LkZODgkBE4n9H24yQdhiEhfurQeK
	c3EICSxjlHi16z87TNGxKdOYIBLTGSWav/9nhnB+MUqcWLmUBaSKTUBN4suXw0AdHBwiAvoS
	bS0aIDXMAlsZJTZ/3M0KUiMkYCtxfslssNWcAnYSn37sZQSxhQV8JDZcug02h0VAVeLKo/dg
	J/EC1bde+MACYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSMJOYfns4O
	USIise/FO0aQeyQE3rJLnP/0hRlil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nm
	WUg2z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkPiduIPx/gHrQ4zJQOsnMkuJ
	JucD4z+vJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYxZdgcf5P9/qbr6nAjrHq8J8gyzjz31+Z58u31hx7bZv++wfo8+8nPuPiOTbc/r7ykc3Cf2
	ZErY4dUr4zUD5k89WrH7i3ZP+NTzV8Iat2xP+znn66VPk/PWTzjSMVtcf/qeVMZffRqSFgvz
	r+Y0KV2eHuOmXzVBY6KuUpZzBcMO/sq9JgHRdtPnKLEUZyQaajEXFScCANnJMJX1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQd2O9+pBBqdWaFvMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDuU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkTJs9nKljMXrHg2QmWBsYZ
	bF2MnBwSAiYSx6ZMY4KwxSQu3FsPFOfiEBKYzijR/P0/M4Tzi1HixMqlLCBVbAJqEl++HGbv
	YuTgEBHQl2hr0QCpYRbYyiix+eNuVpAaIQFbifNLZoNt4BSwk/j0Yy8jiC0s4COx4dJtsDks
	AqoSVx69B9vMC1TfeuEDC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYR
	MJKYf3g6O0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8
	dL3k/NxNjODk8ExqB+PKBotDjAIcjEo8vA3G6kFCrIllxZW5hxglOJiVRHgtVgKFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YuPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKa
	nZpakFoEs4WJg1OqgbHYZNq3x+FvFRg42GbpsGaFs+3q393nK+R96EHKQdZ+x8TPR5yD/IXq
	n8x/eWZbP9OM68b6iseTAgqqN12z2fBHUNZfXGd5SKLdW99w8forPP/ncMzcJBUou8aqI3/W
	n7cJdRyBp/cddU+Y0RIV8Oklr9b/J1sKjV4tf8x6rSdgzznvFz1XopVYijMSDbWYi4oTAaZd
	q6NSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

drivers/video/backlight/ld9040_gamma.h:172:3: warning: symbol 'gamma_table' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040_gamma.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/ld9040_gamma.h b/drivers/video/backlight/ld9040_gamma.h
index 038d9c8..c5e586d 100644
--- a/drivers/video/backlight/ld9040_gamma.h
+++ b/drivers/video/backlight/ld9040_gamma.h
@@ -169,7 +169,9 @@ static const unsigned int ld9040_22_50[] = {
 
 struct ld9040_gamma {
 	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
-} gamma_table = {
+};
+
+static struct ld9040_gamma gamma_table = {
 	.gamma_22_table[0] = (unsigned int *)&ld9040_22_50,
 	.gamma_22_table[1] = (unsigned int *)&ld9040_22_70,
 	.gamma_22_table[2] = (unsigned int *)&ld9040_22_80,
-- 
1.7.10.4


