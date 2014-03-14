Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaCNJbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:31:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaCNJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:25 -0400
X-AuditID: cbfee68e-b7f566d000002344-28-5322cc28717d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 7/8] devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix
 probe fail
Date: Fri, 14 Mar 2014 18:30:07 +0900
Message-id: <1394789408-14648-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkUFfjjFKwwcO5OhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MpYd38ta8Ef9orz136yNzCeY+ti5OSQEDCRmLT4OzOELSZx
	4d56oDgXh5DAUkaJy137WWCKpj7azwiRWMQo8f3YXaiqRiaJD09/M4FUsQloSex/cQNsrIiA
	ucSupT/BipgFnjFJ3OrvAysSFoiUWLBpO9BYDg4WAVWJ2f2KIGFeAVeJm8vfQG2Tk/iw5xE7
	iM0p4CbxtnkaI4gtBFTT132ACWSmhMBHdomG9Z/BilgEBCS+TT4ENlNCQFZi0wGodyQlDq64
	wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMCoOv3vWd8OxpsHrA8xJgONm8gs
	JZqcD4zKvJJ4Q2MzIwtTE1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAKHKmoj6sT6M1J+xzVsU85qKXc569On3tk/a6q3NeZXrMWhp8Yp3K15xdMWunxTw+elZ4
	IWe4QNmXky/m5IV0azk7tfsf1Vv/aK2+SGpWGZfzqzq94DTv7rgikwNRezWYCzbPDf+368fW
	jNR3m45OCQm/aPZQ+ofMda3IvRM2nKuSW5n0Tar0jxJLcUaioRZzUXEiAL9wZFXAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7GGaVgg+f7lS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY939tawFf9grzl/7
	yd7AeI6ti5GTQ0LARGLqo/2MELaYxIV764HiXBxCAosYJb4fuwvlNDJJfHj6mwmkik1AS2L/
	ixtg3SIC5hK7lv4EK2IWeMYkcau/D6xIWCBSYsGm7SxdjBwcLAKqErP7FUHCvAKuEjeXv2GB
	2CYn8WHPI3YQm1PATeJt8zSwK4SAavq6DzBNYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM4Zp9J7WBc2WBxiFGAg1GJh9fhsGKwEGtiWXFl7iFGCQ5mJRFehnlKwUK8KYmVValF
	+fFFpTmpxYcYk4GOmsgsJZqcD0wneSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1O
	TS1ILYLZwsTBKdXAaLf6R+1q0QC93z5LbhgKr5iWu5bld57nyRp9lb7Y0OWPqv0yhOqulWsl
	XFsz/cbVUt/13+6rK53lNjoVt/opNyPjv40G8zemq8xfdN+A3biUwf0mh79S78IZoiYzJk15
	cGJytNCVa1sDgo5XSvAfX7FgpnfRyz/nT230EHt2lZdD1XD2kZv3ryqxFGckGmoxFxUnAgDO
	RuFxHQMAAA==
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

