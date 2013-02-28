Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3B1IpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:45:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21820 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3B1IpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:45:15 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-74-512f191acf79
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 16/19] rtc: rtc-sun4v: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:45:14 +0900
Message-id: <00b401ce158f$ecfddd90$c6f998b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAO98A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA10pSf1Ag5YT0hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlzD36i63gCnfF65YJ7A2M1zm7GDk5JARMJN63LmCBsMUkLtxbz9bFyMUhJLCMUWL5
	ka9sMEXnHnewQiSmM0qc6u1ngnB+MUpMfPwdrIpNQE3iy5fD7F2MHBwiAvoSbS0aIDXMAr2M
	Emd6d7OD1AgJ2Eoca2sDW8cpYCfx++lRVhBbWCBYYk7fYTCbRUBV4nfTfEYQmxeofnf3f3YI
	W1Dix+R7YL3MAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRRPfDP1DlIhL7XrxjBLlH
	QuARu8SkCfdZIHYJSHybfIgFoldWYtMBZoiHJSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKs
	YhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ1f4djHcPWB9iTAZaP5FZSjQ5HxjreSXxhsbG
	JmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOOFZhUFwXsaH
	md99/+kxzvukciW47Yt0oqGC38XIhtOL5/DtqT+43N89h/k3y+cd/zeuk8s+e85i5Zq812xh
	JjN5Dqwx/bDH+YB6EvNep8ZYzY7vd+YmqGUcPKpb/4rXgaNRf6nj0j9Js57WFf3L1KuOWcBV
	2bHGVDr61e49n6odKjbqOGu4KrEUZyQaajEXFScCAIYQM1nrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV0pSf1Ag/bV4hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsw9+out4Ap3xeuWCewNjNc5uxg5OSQETCTO
	Pe5ghbDFJC7cW8/WxcjFISQwnVHiVG8/E4Tzi1Fi4uPvbCBVbAJqEl++HGbvYuTgEBHQl2hr
	0QCpYRboZZQ407ubHaRGSMBW4lhbGwuIzSlgJ/H76VGwDcICwRJz+g6D2SwCqhK/m+Yzgti8
	QPW7u/+zQ9iCEj8m3wPrZRbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCS6H/6BKheR
	2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnAie
	Se9gXNVgcYhRgINRiYe3w0QvUIg1say4MvcQowQHs5IIrwu/fqAQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wOTVF5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi
	4JRqYMxqa4vplXjy05f5/eULzUZ/gpcf1X8gsoPh4GvdiP1/o5wPLG3f8OiF/W6v7Waz/lXK
	5ixaJMv5+Ku98cuVuXa2sVcv1BppSLN/Orp3zsq6D16mf8Kt2m5/VXU6bF3s8CLzzqf5RSdM
	pe3fCU5Ql7ctrzrW2+A2Y6X6edea+EcrNKZLq2ufEVBiKc5INNRiLipOBABO0vRJSAMAAA==
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
 drivers/rtc/rtc-sun4v.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-sun4v.c b/drivers/rtc/rtc-sun4v.c
index 59b5c2d..a819b7c 100644
--- a/drivers/rtc/rtc-sun4v.c
+++ b/drivers/rtc/rtc-sun4v.c
@@ -79,7 +79,7 @@ static const struct rtc_class_ops sun4v_rtc_ops = {
 	.set_time	= sun4v_set_time,
 };
 
-static int __init sun4v_rtc_probe(struct platform_device *pdev)
+static int sun4v_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = rtc_device_register("sun4v", &pdev->dev,
 				     &sun4v_rtc_ops, THIS_MODULE);
@@ -90,7 +90,7 @@ static int __init sun4v_rtc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit sun4v_rtc_remove(struct platform_device *pdev)
+static int sun4v_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -103,7 +103,7 @@ static struct platform_driver sun4v_rtc_driver = {
 		.name	= "rtc-sun4v",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(sun4v_rtc_remove),
+	.remove		= sun4v_rtc_remove,
 };
 
 static int __init sun4v_rtc_init(void)
-- 
1.7.2.5


