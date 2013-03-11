Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3CKCNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:13:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3CKCM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:12:59 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-0c-513d3daa4218
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] pwm: pwm-tiecap: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Mon, 11 Mar 2013 11:12:58 +0900
Message-id: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4d/fLoREAEAFdzR4uo7XL58BGkQQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t8zY91VtraBBv+WSllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M6w/WMxb84qhYNe0yWwPjOfYuRk4OCQETiXvX9kLZYhIX7q1n
	62Lk4hASWMYocf75EbiiuUcb2CESixglFm96xgzhzGaSuNCziQWkik1ATeLLl8NgHSIC5hJL
	Fu0FKuLgYBZwkTg6TQQkLCwQLjHtwhsmEJtFQFVi/aJprCA2r4CtxIsHFxghbEGJH5PvgY1k
	FtCS2LytiRXClpfYvOYt2EgJAXWJR391ITbpSbz5PoENokREYt+Ld4wgp0kItLNLfFz+kxFi
	l4DEt8mHWCB6ZSU2HWCG+EtS4uCKGywTGMVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQi
	Y73ixNzi0rx0veT83E2MkEjp38F494D1IcZkoPUTmaVEk/OBkZZXEm9obGZkYWpiamxkbmlG
	mrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZwg49HY36cW1ex99+Du6VNm11O
	rJgWrXfIcr7H11sFCd8+Nh7p6Mu9cjzh3k7ei8YFaZnsaWrZ01W97t5dt2HKFcMz8lNcenP4
	b8+etO2L/fuTySt3Te1ftlS5cu2W6rDlLUE11SreMWZRsQL1N3a79cyfWPvT2eeT3tINPV3f
	PkyKf/VGddZHJZbijERDLeai4kQAb7lnYqoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd1VtraBBp3NYhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/qD9YwFvzgqVk27zNbA
	eI69i5GTQ0LARGLu0QYoW0ziwr31bF2MXBxCAosYJRZvesYM4cxmkrjQs4kFpIpNQE3iy5fD
	YB0iAuYSSxbtBSri4GAWcJE4Ok0EJCwsEC4x7cIbJhCbRUBVYv2iaawgNq+ArcSLBxcYIWxB
	iR+T74GNZBbQkti8rYkVwpaX2LzmLdhICQF1iUd/dSE26Um8+T6BDaJERGLfi3eMExgFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAcPpPawbiyweIQowAH
	oxIP7wQd20Ah1sSy4srcQ4wSHMxKIrwrN9kECvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+
	MEXklcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOj9b3uJ5Mv
	+LUG3y3/r3zbRlOzQiCkoFzEyrna7V9qf56/zZ8tm9vM9jH98tJqPbLuxKI5nJ6uL1XL2QNe
	neo7tYNr7mXPKs6HIYzpkd7rmRQSy1fvO3NJ8Ki9e6lK7XsbnhWBuYEmAjOSzuv192fP9tAs
	jp2xJ2aH3ynr/r+nqjbrPC9aqKXEUpyRaKjFXFScCABhcITfBwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
the following build warning when CONFIG_PM_SLEEP is not selected.

drivers/pwm/pwm-tiecap.c:314:12: warning: 'ecap_pwm_suspend' defined but not used [-Wunused-function]
drivers/pwm/pwm-tiecap.c:328:12: warning: 'ecap_pwm_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-tiecap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 22e96e2..f024db0 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -311,6 +311,7 @@ void ecap_pwm_restore_context(struct ecap_pwm_chip *pc)
 	writew(pc->ctx.ecctl2, pc->mmio_base + ECCTL2);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int ecap_pwm_suspend(struct device *dev)
 {
 	struct ecap_pwm_chip *pc = dev_get_drvdata(dev);
@@ -337,6 +338,7 @@ static int ecap_pwm_resume(struct device *dev)
 	ecap_pwm_restore_context(pc);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ecap_pwm_pm_ops, ecap_pwm_suspend, ecap_pwm_resume);
 
-- 
1.7.2.5


