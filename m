Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3CKCOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:14:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13007 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3CKCOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:14:44 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-62-513d3e1299ee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
In-reply-to: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
Subject: [PATCH 3/3] pwm: pwm-tiehrpwm: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Mon, 11 Mar 2013 11:14:41 +0900
Message-id: <005501ce1dfe$3141fd30$93c5f790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4d/fLoREAEAFdzR4uo7XL58BGkQQAAC/qA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zfV0hO9tAg3895haXF15itbi8aw6b
	xe6VS1gcmD36plxl8+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6MvZvXsRQs5KyY/nkvcwPj
	V/YuRk4OCQETiRMddxkhbDGJC/fWs3UxcnEICSxjlNhy8zIrTNGTrb+ZIRLTGSW6/r5ihHB+
	MUp86X7LBlLFJqAm8eXLYbCxIgLmEksW7QXq4OBgFnCRODpNBCQsJGArsfDcZWYQm1PATuLT
	rBVgm4UFIiWO7O1iArFZBFQlet8eBrN5geqvr5vCDmELSvyYfI8FxGYW0JLYvK2JFcKWl9i8
	5i3YKgkBdYlHf3VBTBEBI4n/360hKkQk9r14B3axhMAhdokZW+4zQqwSkPg2+RALRKusxKYD
	zBDvSkocXHGDZQKjxCwki2chWTwLyeJZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7
	iRESfxN3MN4/YH2IMRlo/URmKdHkfGD85pXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBcfKRhfLB0u3fki49crL+qPXz1Wm370bl++tfOqXMrhfz
	CFGymuhwNnpXy/PAqzd2cmteMRV5a1hQ/kf01h3LOKs3cz6npf1cZ/Byhtiar38OHdL3eNrA
	/W9jhLXjvZiZ6kod3je4N7wXXVl2T1XwDcs+qc/T1r9yb1PZ7cbvzXq7KPiA4V+21UosxRmJ
	hlrMRcWJAJseLCLVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV0hO9tAg217jS0uL7zEanF51xw2
	i90rl7A4MHv0TbnK5tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGXs3r2MpWMhZMf3zXuYGxq/sXYycHBICJhJPtv5mhrDFJC7cW8/WxcjFISQwnVGi
	6+8rRgjnF6PEl+63bCBVbAJqEl++HAbrFhEwl1iyaC9QNwcHs4CLxNFpIiBhIQFbiYXnLoMN
	5RSwk/g0awUjiC0sEClxZG8XE4jNIqAq0fv2MJjNC1R/fd0UdghbUOLH5HssIDazgJbE5m1N
	rBC2vMTmNW/BVkkIqEs8+qsLYooIGEn8/24NUSEise/FO8YJjEKzkAyahWTQLCSDZiFpWcDI
	sopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLqfSe9gXNVgcYhRgINRiYd3go5toBBrYllx
	Ze4hRgkOZiUR3pWbbAKFeFMSK6tSi/Lji0pzUosPMSYD/TmRWUo0OR+YePJK4g2NTcyMLI3M
	LIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgdEre3bTkveqrZ+aJU4+UvUpPnU5
	+Gm+z7XF4X+yjXZNX77p14MVghm3/Hza3r06f50r84nKpBsvrp2SKJmadqSk5vOuVeFbUi4W
	72715P1fuW351zKdu967wtL9P76as1L0YFDtMTfrbK33IXZZS/tankxdoOblH6W+O5XJLvTt
	cudJF9bUXL2jxFKckWioxVxUnAgAscd9NjIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
the following build warning when CONFIG_PM_SLEEP is not selected.

drivers/pwm/pwm-tiehrpwm.c:562:12: warning: 'ehrpwm_pwm_suspend' defined but not used [-Wunused-function]
drivers/pwm/pwm-tiehrpwm.c:580:12: warning: 'ehrpwm_pwm_resume' defined but not used [-Wunused-function

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-tiehrpwm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 8b4c86f..d058ba9 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -559,6 +559,7 @@ void ehrpwm_pwm_restore_context(struct ehrpwm_pwm_chip *pc)
 	ehrpwm_write(pc->mmio_base, TBCTL, pc->ctx.tbctl);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int ehrpwm_pwm_suspend(struct device *dev)
 {
 	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
@@ -594,6 +595,7 @@ static int ehrpwm_pwm_resume(struct device *dev)
 	ehrpwm_pwm_restore_context(pc);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ehrpwm_pwm_pm_ops, ehrpwm_pwm_suspend,
 		ehrpwm_pwm_resume);
-- 
1.7.2.5


