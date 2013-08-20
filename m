Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3HTHBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:01:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58500 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3HTHB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:01:28 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c6-521314474ae3
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] mfd: pm8921: include missing linux/module.h
Date: Tue, 20 Aug 2013 16:01:26 +0900
Message-id: <005201ce9d73$1696e230$43c4a690$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dcsYnueWfrkZHSWmgV0M1In20Fg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zY113EeEgg39drBb/jk1hsni8/B+b
	xdRlbawWlxdeYrW4//Uoo8XlXXPYLE53szqwe1zu62XyOD15P4vHnWt72DzmnQz06NuyitHj
	8ya5ALYoLpuU1JzMstQifbsEroxdG56zF3xmr3i1YA1jA+NTti5GTg4JAROJycc/sUDYYhIX
	7q0HinNxCAksY5T40TwXyOEAK5o70RYivohR4tmLG8wQzi9GiWPLP4BNYhNQk/jy5TA7SIOI
	gJfErTtBIDXMAtsZJW5fesUIUiMs4CAxqaeJCcRmEVCVWH75BSuIzStgKTH18GImCFtQ4sfk
	e2AXMQtoSazfeZwJwpaX2LzmLTPEpQoSO86+BpspIqAnsez8R6h6EYl9L94xgiyWELjGLrG5
	ZTcjxDIBiW+TD7FAfCMrsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguK
	k9KLTPWKE3OLS/PS9ZLzczcxQqJy4g7G+wesDzEmA62fyCwlmpwPjOq8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB6rtvEGDb9YMQu6TPpjats
	d69J+Z32iSNU/UbCM7Y7n8XOGEzVLmE9LNRorX/Y3vyHR1lXnPY937S0yyISdm/Z2tPqKm5e
	/XnOV3pb8CdHFaUb6ZWLm5lSps7lfrDtqiOvSYHAvDzJrfaLxYqVk1a8Or77pxBjRKTl/jui
	F27oLBVnUXvmHqPEUpyRaKjFXFScCABWpM4u4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV13EeEgg8Z2Rot/x6YwWTxe/o/N
	YuqyNlaLywsvsVrc/3qU0eLyrjlsFqe7WR3YPS739TJ5nJ68n8XjzrU9bB7zTgZ69G1Zxejx
	eZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtApSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMXRuesxd8Zq94tWAN
	YwPjU7YuRg4OCQETibkTbbsYOYFMMYkL99YDhbk4hAQWMUo8e3GDGcL5xShxbPkHNpAqNgE1
	iS9fDrODNIsIeEncuhMEUsMssJ1R4valV4wgNcICDhKTepqYQGwWAVWJ5ZdfsILYvAKWElMP
	L2aCsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPERQoSO86+BpspIqAnsez8R6h6EYl9L94x
	TmAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx/0x6B+Oq
	BotDjAIcjEo8vB1KQkFCrIllxZW5hxglOJiVRHhd/gOFeFMSK6tSi/Lji0pzUosPMSYDfTqR
	WUo0OR+YjvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVGO
	+1/HT/nCSWy7jn3tXcQW/FjUwlGzoOrgmj3dneelGLtM0rbrFYVurDD8492yImfNsytpM5pE
	9733dj8XV77jUYidd8AkJ9YFRWUymepOV/+2zQ5cr5IvsaMusEkies8+xbsclr67fLIPPZT5
	nGHeqfDBRHB9c2IUZ+tJb6kLz3de5OKYocRSnJFoqMVcVJwIAK6svKo9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include <linux/module.h> in order to fix the following errors.

drivers/mfd/pm8921-core.c:209:16: error: expected declaration specifiers or '...' before string constant
drivers/mfd/pm8921-core.c:210:20: error: expected declaration specifiers or '...' before string constant
drivers/mfd/pm8921-core.c:211:16: error: expected declaration specifiers or '...' before string constant
drivers/mfd/pm8921-core.c:212:14: error: expected declaration specifiers or '...' before string constant

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/pm8921-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 9be6840..bd4b37c 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-- 
1.7.10.4


