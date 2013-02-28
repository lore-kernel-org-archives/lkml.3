Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3B1Imq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:42:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36814 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3B1Imn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:42:43 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-cb-512f18825890
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 10/19] rtc: rtc-rp5c01: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:42:42 +0900
Message-id: <00ae01ce158f$92a7a510$b7f6ef30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAJOtQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfd0mCf1Ag0WXDC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmUsdTAUt3BXdnw6yNzDO4Oxi5OSQEDCReN41gQ3CFpO4cG89
	kM3FISSwjFHi+7PLbDBFR8/OYIZILGKUOH/jL1TVbCaJjsOrmEGq2ATUJL58OczexcjBISKg
	L9HWogFSwyzQyyhxpnc3O0iNkICtxLG2NhYQm1PATuL306OsILawQIhEz9ZGFpBeFgFViV+v
	HEHCvEDlJ5e/ZIKwBSV+TL4H1sosoCWxfudxJghbXmLzmrfMIK0SAuoSj/7qgoRFBIwkPt5o
	ZYYoEZHY9+IdI8g5EgLL2CVmbnkKdg6LgIDEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8
	C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkMjq28F484D1IcZkoPUT
	maVEk/OBkZlXEm9obGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYwiKa/jEwNWdy/43fZgxS2NO0tn91yPv5G+h/evi9Hzxof8n24qBfkr/A7/k1rF6ZyR
	I9Ac4dZeZ6l24v8l1en777Ju+3uDa96OJZIWby56fdp/7d+dDyu014aHHzpZbPl5ksDKyclT
	Hxk+T5bk27xesPf6uycuvNesOjzz53YnNgjUd7xT1TZSYinOSDTUYi4qTgQA/xWE2MICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG6ThH6gwZKH2haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48ylDqaCFu6K7k8H2RsY
	Z3B2MXJySAiYSBw9O4MZwhaTuHBvPVsXIxeHkMAiRonzN/5CObOZJDoOrwKrYhNQk/jy5TB7
	FyMHh4iAvkRbiwZIDbNAL6PEmd7d7CA1QgK2Esfa2lhAbE4BO4nfT4+ygtjCAiESPVsbWUB6
	WQRUJX69cgQJ8wKVn1z+kgnCFpT4MfkeWCuzgJbE+p3HmSBseYnNa94yg7RKCKhLPPqrCxIW
	ETCS+HijlRmiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZw3D6T3sG4qsHiEKMAB6MSD2+HiV6gEGtiWXFl7iFGCQ5mJRFeF379QCHelMTK
	qtSi/Pii0pzU4kOMyUB/TmSWEk3OB6aUvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8s
	Sc1OTS1ILYLZwsTBKdXAKKt06o/42j2+XRIBz8RuGbn9mniw+MnRyS+dPULUVvy12bUrzKKt
	K23u6oy0CWKT+fIdLM0sjk47OvOnYYn0qqlnLtirJLs57Hzp37ktQKVaNM8vRc246lVI0tep
	s8y2hszucQ4smtHVdvDqd+3PlnYbdQQ3dd5n6k/WPpOzztR2oYNmXGqVEktxRqKhFnNRcSIA
	o83JHR8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rp5c01.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 359da6d..da4f6c4 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -219,7 +219,7 @@ static ssize_t rp5c01_nvram_write(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static int __init rp5c01_rtc_probe(struct platform_device *dev)
+static int rp5c01_rtc_probe(struct platform_device *dev)
 {
 	struct resource *res;
 	struct rp5c01_priv *priv;
@@ -275,7 +275,7 @@ out_free_priv:
 	return error;
 }
 
-static int __exit rp5c01_rtc_remove(struct platform_device *dev)
+static int rp5c01_rtc_remove(struct platform_device *dev)
 {
 	struct rp5c01_priv *priv = platform_get_drvdata(dev);
 
@@ -291,7 +291,7 @@ static struct platform_driver rp5c01_rtc_driver = {
 		.name	= "rtc-rp5c01",
 		.owner	= THIS_MODULE,
 	},
-	.remove	= __exit_p(rp5c01_rtc_remove),
+	.remove	= rp5c01_rtc_remove,
 };
 
 static int __init rp5c01_rtc_init(void)
-- 
1.7.2.5


