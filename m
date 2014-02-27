Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaB0Lk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:40:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaB0LkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:40:21 -0500
X-AuditID: cbfee68f-b7f156d00000276c-b0-530f2424be4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
Subject: [PATCH 1/2] rtc: as3722: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:40:20 +0900
Message-id: <000c01cf33b0$b1b3e050$151ba0f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zsLGZwyDXiYdLTDm9mZzbm6I0DA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zQ10VFf5gg0339C2WXLzKbjFn/Ro2
	i8sLL7FaLN23msXi8q45bBb7OzsYHdg89kw8yeZxYsZvFo/e5ndsHn1bVjF6TJ/3k8nj8ya5
	ALYoLpuU1JzMstQifbsEroytbxeyFfSzVSxc08rawDiZtYuRk0NCwERi/Y3TLBC2mMSFe+vZ
	uhi5OIQEljFK/LoymQ2m6Nu9LqjEIkaJE5/eMIMkhAR+M0o8PRgCYrMJqEl8+XKYvYuRg0NE
	QF+irUUDpJ5ZYCejxNqu2WD1wgK2EtNvbWQHsVkEVCVmr7wFtpkXKH6uewIzhC0o8WPyPbA4
	s4CWxPqdx5kgbHmJzWveMoPMlxBQl3j0VxckLCKgJ3H79DuoEhGJfS/eMYLslRC4xi7x7QjE
	ZywCAhLfJh9igeiVldh0gBniL0mJgytusExgFJuFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT
	0ouM9YoTc4tL89L1kvNzNzFCorF/B+PdA9aHGJOB1k9klhJNzgdGc15JvKGxmZGFqYmpsZG5
	pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBTumnL9tI2C7xrZIxfWqUWE
	X/FMU82y2fujNiOqOz7EyaLtce9UnSM8udNrv+9yW7PT6Ns2dUve/M2rCrZPZMtz6r/O+WzJ
	94AprqpntJVP1sRM8nhV7G/vrJdQ/umv7jOZzkSBtR+7Dmdf8cg+fWBxKL+njc3PUpsFjneb
	pPKnb/Qo9t60TomlOCPRUIu5qDgRAK8msCncAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAV0VFf5gg9XNOhZLLl5lt5izfg2b
	xeWFl1gtlu5bzWJxedccNov9nR2MDmweeyaeZPM4MeM3i0dv8zs2j74tqxg9ps/7yeTxeZNc
	AFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMrW8XshX0s1UsXNPK2sA4
	mbWLkZNDQsBE4tu9LjYIW0ziwr31QDYXh5DAIkaJE5/eMIMkhAR+M0o8PRgCYrMJqEl8+XKY
	vYuRg0NEQF+irUUDpJ5ZYCejxNqu2WD1wgK2EtNvbWQHsVkEVCVmr7zFAmLzAsXPdU9ghrAF
	JX5MvgcWZxbQkli/8zgThC0vsXnNW2aQ+RIC6hKP/uqChEUE9CRun34HVSIise/FO8YJjAKz
	kEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjONafSe9gXNVgcYhR
	gINRiYf3hy5fsBBrYllxZe4hRgkOZiUR3vVM/MFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWa
	nA9MQ3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwOi9Ufe5
	Vfvnu4GBdqnb2R8t2fXeQ6dy8odZ2yYf3OTif2H56UbXydKPL3euPfz6cu6UUy8OpPgyTGGT
	Ptyx5Lko08H0D37LNL5KrDJpevP1jcbqDbv/X74bPtGt7WbmicDj/WEmjypapFa/nFVR9FpK
	RVpQouucIKMd1095z5V76s59PNy22XiuEktxRqKhFnNRcSIAnuQmRzkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-as3722.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-as3722.c b/drivers/rtc/rtc-as3722.c
index 4af0169..9f38eda 100644
--- a/drivers/rtc/rtc-as3722.c
+++ b/drivers/rtc/rtc-as3722.c
@@ -242,9 +242,8 @@ static int as3722_rtc_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops as3722_rtc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(as3722_rtc_suspend, as3722_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(as3722_rtc_pm_ops, as3722_rtc_suspend,
+			 as3722_rtc_resume);
 
 static struct platform_driver as3722_rtc_driver = {
 	.probe = as3722_rtc_probe,
-- 
1.7.10.4


