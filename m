Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3B1Ikq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:40:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20914 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3B1Ikl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:40:41 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-74-512f1808882d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 05/19] rtc: rtc-efi: remove erroneous __init/__exit annotations
Date: Thu, 28 Feb 2013 17:40:39 +0900
Message-id: <00a901ce158f$49abb720$dd032560$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAE56g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA10OCf1Ag6VTRCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG8yd2BQ+4Kg51LmFtYPzE0cXIySEhYCKx+tkxVghbTOLCvfVs
	XYxcHEICyxglTt1uZIMp2rd0GxNEYhGjRMOl3SwQzmwmieWff7GAVLEJqEl8+XKYvYuRg0NE
	QF+irUUDpIZZoJdR4kzvbnaQGiEBW4ljbW1g9ZwCdhK/nx4FWy0s4C/xbWsTE4jNIqAq8f4A
	xExeoPrW5RPYIWxBiR+T74HFmQW0JNbvPM4EYctLbF7zlhlkr4SAusSjv7ogYREBI4nzTyYx
	Q5SISOx78Y4R5B4JgWXsEhd7JkLtEpD4NvkQC0SvrMSmA8wQD0tKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRElkTdzDeP2B9iDEZaP1EZinR
	5HxgZOaVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A6PAPolswWPHPHnr/dhOPmi+epvr1dzXevubD+uErXj2/YL5zBL7nvhyZd+79nlBu6OYtCRj
	Op9u/Rhn0Vkn4MwVxfxmieRrbbP4iJ9hGgZPdgpdmrhfbOmtTRcZPDsnSxqtjz/ewfS24MAS
	ycuT+SOFeWZaGv59Nz3TQZyHafbSS/6Tsuc/klZiKc5INNRiLipOBABQ81y4wgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgC6HhH6gwbS7AhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/kTu4IHXBWHOpewNjB+
	4uhi5OSQEDCR2Ld0GxOELSZx4d56ti5GLg4hgUWMEg2XdrNAOLOZJJZ//sUCUsUmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u9lBaoQEbCWOtbWB1XMK2En8fnqUFcQWFvCX+La1CWwb
	i4CqxPsDEDN5gepbl09gh7AFJX5MvgcWZxbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUE
	jCTOP5nEDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzhun0nvYFzVYHGIUYCDUYmHt8NEL1CINbGsuDL3EKMEB7OSCK8Lv36gEG9KYmVV
	alF+fFFpTmrxIcZkoEcnMkuJJucDU0peSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5ak
	ZqemFqQWwWxh4uCUamDMTw76LPh3R8nf284R8+S3h/8q/H/zk3JbwIzz6xYYb/t0fvsp7ozJ
	uy0u803NXBRlfqeCmUds9WOX4w16j78udmfpuhu1W2v3UbXLMisO+jGqzP7R6OLo6sZ/O0m8
	9/P8qgVOt0qnmiycfPL5ybXRf17nvHqzRLJw5dYLr5Ku/lHOlhLWFD23SomlOCPRUIu5qDgR
	AD3rxhofAwAA
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
 drivers/rtc/rtc-efi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 1a0c37c..71ac803 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -187,7 +187,7 @@ static const struct rtc_class_ops efi_rtc_ops = {
 	.set_alarm = efi_set_alarm,
 };
 
-static int __init efi_rtc_probe(struct platform_device *dev)
+static int efi_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
@@ -201,7 +201,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __exit efi_rtc_remove(struct platform_device *dev)
+static int efi_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
@@ -215,7 +215,7 @@ static struct platform_driver efi_rtc_driver = {
 		.name = "rtc-efi",
 		.owner = THIS_MODULE,
 	},
-	.remove = __exit_p(efi_rtc_remove),
+	.remove = efi_rtc_remove,
 };
 
 static int __init efi_rtc_init(void)
-- 
1.7.2.5


