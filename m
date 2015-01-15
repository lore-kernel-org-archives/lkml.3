Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbbAOORW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:17:22 -0500
Received: from m12-11.163.com ([220.181.12.11]:41730 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbbAOORT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:17:19 -0500
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 09:17:18 EST
From: Yaowei Bai <bywxiaobai@163.com>
To: rjw@rjwysocki.net, lenb@kernel.org, corbet@lwn.net
Cc: linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/acpi: add the missing '='
Date: Thu, 15 Jan 2015 21:59:16 +0800
Message-Id: <1421330356-4051-1-git-send-email-bywxiaobai@163.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: C8CowEBZmVoryLdUEnmuAA--.5S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4Uur13Wr13AF4UCrW3KFg_yoWxCrX_u3
	WDXFsYqay7t3W8Xw1xX3s8AF17Gr4xKF1rC3WxCr4DC3W8ArWDZF90vryqv3y5Wr4xury5
	WFn5CrWUJry2vjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0nF4tUUUUU==
X-Originating-IP: [58.209.167.106]
X-CM-SenderInfo: xe1z5x5dretxi6rwjhhfrp/xtbBFBuCT1D+VsyO0QAAsp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
---
 Documentation/acpi/enumeration.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index b60d2ab..9b121a5 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -243,7 +243,7 @@ input driver:
 			.owner	= THIS_MODULE,
 			.pm	= &mpu3050_pm,
 			.of_match_table = mpu3050_of_match,
-			.acpi_match_table  ACPI_PTR(mpu3050_acpi_match),
+			.acpi_match_table = ACPI_PTR(mpu3050_acpi_match),
 		},
 		.probe		= mpu3050_probe,
 		.remove		= mpu3050_remove,
-- 
1.9.1


