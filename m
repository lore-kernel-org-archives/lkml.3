Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaCMITI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:19:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaCMIR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:58 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-9b-5321699f62f1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 7/8] devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix
 probe fail
Date: Thu, 13 Mar 2014 17:17:28 +0900
Message-id: <1394698649-20996-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUHd+pmKwwcLXphYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MpYd38ta8Ef9orz136yNzCeY+ti5OSQEDCRuLDsHSOELSZx
	4d56oDgXh5DAUkaJVzdfMsEUTfo4hREiMZ1R4s/yU1BVjUwScx/NYQepYhPQktj/4gbYWBEB
	c4ldS3+CFTELPGOSuNXfBzZKWCBS4sWmk8wgNouAqsS7709ZQWxeAVeJXW+fQd0hJ/FhzyOw
	oZwCbhI3704D6xUCqrnQOoUZZKiEwFt2iW1/2hghBglIfJt8iKWLkQMoISux6QAzxBxJiYMr
	brBMYBRewMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwrk7/e9a7g/H2AetDjMlA4yYy
	S4km5wPjMq8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGNuZC78tzZJLVNu4vGKiu9LEZes2VVx4EVGg5hHG78QXfE/+e9yi9gSOh1HZXa8rJl8q
	P/beb/llgVjvmICqZaGdnx5K/p8rvb8+6ri4dutjWTldt2nxv/4s/nM7z1as6b910enf+fWl
	e8uns1z9ejBNO94hI3S75YzEb0+U373znLDjY7DvcSWW4oxEQy3mouJEAOPSRObBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO78TMVgg1t7dS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY939tawFf9grzl/7
	yd7AeI6ti5GTQ0LARGLSxymMELaYxIV764HiXBxCAtMZJf4sPwXlNDJJzH00hx2kik1AS2L/
	ixtg3SIC5hK7lv4EK2IWeMYkcau/jwkkISwQKfFi00lmEJtFQFXi3fenrCA2r4CrxK63z6DW
	yUl82PMIbCingJvEzbvTwHqFgGoutE5hnsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcNQ+k97BuKrB4hCjAAejEg/viuUKwUKsiWXFlbmHGCU4mJVEeD19FIOFeFMSK6tSi/Lj
	i0pzUosPMSYDXTWRWUo0OR+YUPJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpa
	kFoEs4WJg1OqgdFZRVnUZsr8s4dq9LnfK5xdssBj3gSFiJXsaZMNZ0xs8pwv0bcr/MzfgxvO
	LcjPq/gXM/OD5Iy6jlfdFt4PO/85xoqeac1Xut6msmFJ1uY3YWs3nbYTmeOvt++EwQXjtb9P
	MVpaJ2Tl765lVWqZUbPxsEzOjzOl3A6lr9401TnmFafH8Vg9eKbEUpyRaKjFXFScCABRwibg
	HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add CONFIG_PM_OPP dependecy to exynos4_bus driver
to fix probe fail as following log:

[    3.721389] exynos4-busfreq busfreq.3: Fail to add opp entries.
[    3.721697] exynos4-busfreq: probe of busfreq.3 failed with error -22

If CONFIG_PM_OPP is disabled, dev_pm_opp_find_freq_floor() in xxx_probe()
will always return -EINVAL error.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 7d2f435..b2de2a1 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -70,6 +70,7 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412) && !ARCH_MULTIPLATFORM
 	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select PM_OPP
 	help
 	  This adds the DEVFREQ driver for Exynos4210 memory bus (vdd_int)
 	  and Exynos4212/4412 memory interface and bus (vdd_mif + vdd_int).
-- 
1.8.0

