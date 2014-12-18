Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaLRKPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:15:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54598 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLRKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:15:20 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-0d-5492a935541e
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 9/9] hwmon: thermal: dts: Disable FAN on boot on the Odroid U3
Date: Thu, 18 Dec 2014 11:13:11 +0100
Message-id: <1418897591-18332-10-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQV3TlZNCDFpPy1rMP3KO1WL+lWus
	FkvvfmKz+PH6AptF74KrbBZvHnFbvHm4mdHi8q45bBafe48wWsw4v4/J4snCM0wWd6btZbM4
	/Kad1YHXY+esu+weDybuZvNYN+0ts8fO7w3sHn1bVjF6bD5d7fF5k1wAexSXTUpqTmZZapG+
	XQJXxuyZP1kL/rFUvJ/E2sA4laWLkZNDQsBEYufS7ewQtpjEhXvr2boYuTiEBKYzSry9f4cZ
	wulikjj4/CVYB5uAnsTnu0+ZQBIiAjMYJfY3fWMHcZgFvjNJNG1dClYlLOAncWNOOzOIzSKg
	KnH/8wNGEJtXwF3i4sYjrBD7FCW6n01gA7E5geJznkPYQgJuEk1/LzFPYORdwMiwilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM4SJ9J72Bc1WBxiFGAg1GJh1dCb1KIEGtiWXFl7iFGCQ5m
	JRHe6BygEG9KYmVValF+fFFpTmrxIUZpDhYlcV4l+7YQIYH0xJLU7NTUgtQimCwTB6dUA6ND
	uXBcgZx7b5Q1o+qaqjmzqi4Y3An0t43PTV6bqD5JRGXvrzSxB0WV52z0n68rr4xi2rVzhuz5
	zb7nAxu/F/m5bfLgOtSgEOO3dnuVsvbjPwyL5Y3Vduvd0uhdH/aJ4dqu/UVX/FdttWk1Ltqc
	/nX5g0v+qdfrylTkn2R/ZZl8a2uVRhp7vRJLcUaioRZzUXEiAMR5nCNOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By specifying default-pulse-width to zero, disable FAN on boot.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index cc50e96..fec063e 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -39,6 +39,7 @@
 		cooling-max-state = <3>;
 		#cooling-cells = <2>;
 		cooling-pwm-values = <0 102 170 255>;
+		default-pulse-width = <0>;
 		status = "okay";
 	};
 
-- 
2.0.0.rc2

