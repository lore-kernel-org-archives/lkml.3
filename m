Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3IEESZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:18:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49496 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3IEESX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:18:23 -0400
X-AuditID: cbfee68e-b7f756d000004512-94-5228060936f6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
In-reply-to: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
Subject: [PATCH V2 3/6] backlight: ld9040: Staticize local variable gamma_table
Date: Thu, 05 Sep 2013 13:18:16 +0900
Message-id: <001001cea9ee$f203f7e0$d60be7a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p7mBpdyq9ywYnR82rhDmFCL2hBAAAGaeg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY11ONo0gg+P3mS3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxoTJ85kKFrNXLHh2gqWBcQZbFyMnh4SAiUT3xGnMELaYxIV764Hi
	XBxCAssYJeb2HWaBKbr1soEdIjGdUWL6qdWMEM4vRolFn66AtbMJqEl8+XIYqIqDQ0RAX6Kt
	RQOkhllgK6PE5o+7WUHiQgK2Eo838oKUcwrYSSx9focJxBYW8Jd4/n4KI4jNIqAq8flpMxNI
	OS9Q+fvDeiBhXgFBiR+T74HdwyygJbF+53EmCFteYvOat8wg5RIC6hKP/uqChEUEjCT61jxj
	hygRkdj34h3YxRICH9klWj8vYYJYJSDxbfIhFoheWYlNB6DhIClxcMUNlgmMErOQbJ6FZPMs
	JJtnIVmxgJFlFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZI7PbtYLx5wPoQYzLQ+onMUqLJ
	+cDYzyuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	45IJ2vyGO6Oz3q/7wL9j88QLs5zmJ1/rXGDCwzMh2e2f7HlFrdTSr/922GzaHOISUH/+QNL1
	57d+9j93X1XJKuZ3wFtpqa/jyfnKnvuTd9zzzTr9OiGrv+JvypYtC4IuZec7i8a+qjumuphL
	+8PmzLl65bUbDnQduFm6csKsf2FbGWXUL2ftWqzEUpyRaKjFXFScCADcelXn8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQV0ONo0gg4sXbCzmrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xowJk+czFSxmr1jw7ARLA+MM
	ti5GTg4JAROJWy8b2CFsMYkL99YDxbk4hASmM0pMP7WaEcL5xSix6NMVZpAqNgE1iS9fDgN1
	cHCICOhLtLVogNQwC2xllNj8cTcrSFxIwFbi8UZekHJOATuJpc/vMIHYwgL+Es/fT2EEsVkE
	VCU+P21mAinnBSp/f1gPJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmUHKJQTUJR791QUJ
	iwgYSfStecYOUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjODE8k9rBuLLB4hCjAAejEg9vg7F6kBBrYllxZe4hRgkOZiURXouVQCHelMTK
	qtSi/Pii0pzU4kOMyUB/TmSWEk3OByatvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeW
	pGanphakFsFsYeLglGpg5L200KPq3sS0t5UH0osFdSdu+z15t87jEKVqL5lelctdShVBH8TT
	dzT5uizdoTu37JblN9EPjAZHMx/+CcgT1rt1xIxJ/XyY2Gync2bn+/mVbdqnnLhy5liOjVbm
	Fa5fTL2Sqz+znNU+ektWWI7xyIutNe6c63bkfzOZsV5o9XoNEb5ktWB1JZbijERDLeai4kQA
	lGplSFADAAA=
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


