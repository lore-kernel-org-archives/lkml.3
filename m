Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3DDI1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:27:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40726 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141Ab3DDI1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:27:51 -0400
X-AuditID: cbfee68e-b7f946d000001e37-4c-515d3985b6c4
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Kukjin'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.ab@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] ARM: EXYNOS: Fix crash on soft reset on EXYNOS5440
Date: Thu, 04 Apr 2013 17:27:48 +0900
Message-id: <000101ce310e$4a8c3990$dfa4acb0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zQ91Wy9hAg3l9ghZLmrktehdcZbO4
	vGsOm8WCjY8YLTqWMTqwevRtWcXo8XmTXABTFJdNSmpOZllqkb5dAlfGpFuXmQrOclesnjKJ
	qYHxIGcXIyeHhICJxMquV+wQtpjEhXvr2boYuTiEBJYxSrR8a2CHKXpzrY0ZIjGdUWJq+0VG
	COcvo8ScnxtZQarYBHQljq3fAmaLCHhLnJryixnEZhbIkLjScBAozgHUwC2xujkIJMwpwCOx
	7k8nWImwgJ/Euh8zwZaxCKhKdC38ygJi8wrYSew4/4wNwhaU+DH5HgvESC2J9TuPM0HY8hKb
	17xlBhkvIaAu8eivLsQFThLrz7RBlYtI7HvxDuxkCYFD7BKzZqxmgtglIPFt8iEWiF5ZiU0H
	mCH+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93
	EyMkDvt2MN48YH2IMRlo/URmKdHkfGAc55XEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBUdfkv8uS1/N8p+2sz3ncVhwX5ba04Bnzz6WFpjmix8PD
	797bzNTlkmrwZ0GY8Y5cu/RrYhWL467/UjEwSmLmv/Y+ctdbHdfrjLNXrT0zafP5Sq17nTv/
	v5TPEHR9ddPifJLdX8PkGVNmac2XC214Nefudv2yW7FnDNn2xEcy35Dvnj6n8i6bsxJLcUai
	oRZzUXEiALYLLrjZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQd1Wy9hAg95/3BZLmrktehdcZbO4
	vGsOm8WCjY8YLTqWMTqwevRtWcXo8XmTXABTVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QMiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYR1jxqRbl5kKznJXrJ4yiamB8SBnFyMnh4SAicSba23MELaYxIV769m6GLk4hASm
	M0pMbb/ICOH8ZZSY83MjK0gVm4CuxLH1W8BsEQFviVNTfoF1MwtkSFxpOAgU5wBq4JZY3RwE
	EuYU4JFY96cTrERYwE9i3Y+Z7CA2i4CqRNfCrywgNq+AncSO88/YIGxBiR+T77FAjNSSWL/z
	OBOELS+xec1bZpDxEgLqEo/+6kJc4CSx/kwbVLmIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEj
	yypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ch/Jr2DcVWDxSFGAQ5GJR7eFf4xgUKsiWXF
	lbmHGCU4mJVEeN15YgOFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YgPJK4g2NTcyMLI3M
	LIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgVHp376tbS4bVhXltBWlrOk8EVvv
	LPHvx68DO+T+PePtVjfvOvPl6MGMNG8LnerJlb9afddYCH5aX6xWG2DvLBTScWy2VaBxsRh3
	fuDZau1Asxb2i3uenmUy/npgwVs1Bfv7+xqWKW6eNVHo/MO33VXvr539tfYb+3fXDJlDvZfY
	u394/Q40YlNiKc5INNRiLipOBAAv7gwHNgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Thomas Abraham <thomas.ab@samsung.com>"

The soft-reset control register is located in the XMU controller space.
Map this controller space before writing to the soft-reset controller
register.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Signed-off-by: Girish K S <ks.giri@samsung.com>
Signed-off-by: Kukjin <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-exynos/common.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 1a89824..3b6de7a 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -299,6 +299,7 @@ void exynos4_restart(char mode, const char *cmd)
 
 void exynos5_restart(char mode, const char *cmd)
 {
+	struct device_node *np;
 	u32 val;
 	void __iomem *addr;
 
@@ -306,8 +307,9 @@ void exynos5_restart(char mode, const char *cmd)
 		val = 0x1;
 		addr = EXYNOS_SWRESET;
 	} else if (of_machine_is_compatible("samsung,exynos5440")) {
-		val = (0x10 << 20) | (0x1 << 16);
-		addr = EXYNOS5440_SWRESET;
+		np = of_find_compatible_node(NULL, NULL,
"samsung,exynos5440-clock");
+		addr = of_iomap(np, 0) + 0xcc;
+		val = (0xfff << 20) | (0x1 << 16);
 	} else {
 		pr_err("%s: cannot support non-DT\n", __func__);
 		return;
-- 
1.7.9.5


