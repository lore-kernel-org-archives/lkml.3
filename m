Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaCTC72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:59:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaCTC7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:59:23 -0400
X-AuditID: cbfee68f-b7f156d00000276c-e7-532a59896a15
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, t.figa@samsaung.com, b.zolnierkie@samsaung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 3/5] devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix
 probe fail
Date: Thu, 20 Mar 2014 11:59:11 +0900
Message-id: <1395284353-22458-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkRLczUivY4NwTA4uOnt8sFte/PGe1
	ONv0ht3i8q45bBYzzu9jsrjduILN4vGKt+wWN6fOZnLg8Fi85yWTx8/l29k9+rasYvT4vEku
	gCWKyyYlNSezLLVI3y6BK2Pd/bWsBX/YK85f+8newHiOrYuRk0NCwESi6/18ZghbTOLCvfVA
	cS4OIYGljBIHV1xghSk60H2HHSKxiFFizvwtTBBOI5PE+hfHmUCq2AS0JPa/uAE2VkTAXGLX
	0p9go5gFdjJK7L+9iBEkISwQKdHy4AsLiM0ioCrRd/gs2G5eAVeJsx2noO6Qk/iw5xE7iM0p
	4CZx9PFssKFCQDUfeh6BnSEhMI9douVtFxPEIAGJb5MPAQ3lAErISmw6ADVHEuiFGywTGIUX
	MDKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAgM9dP/nvXvYLx7wPoQYzLQuInMUqLJ+cBY
	ySuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJLi
	0qyxpqwWbRnmaizsR+ewHWuYHmck6DkhIuas7jvWFZ+Vw0tXrpXfKaPqvNR4l5iPwJGjnZtV
	F/nGXd5+y11QeYZ8+cvfDd5rinyUMnS3LUlYbGR+ht+WQ/jOuu+16okRp6KC5/+Zz7rpgGS4
	7Pr5HaFWM1LuX2dbrpZ1hsns0bPlU+ddUGIpzkg01GIuKk4EAMj2QMKLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd3OSK1ggxf/1C06en6zWFz/8pzV
	4mzTG3aLy7vmsFnMOL+PyeJ24wo2i8cr3rJb3Jw6m8mBw2PxnpdMHj+Xb2f36NuyitHj8ya5
	AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ6+6vZS34w15x/tpP9gbG
	c2xdjJwcEgImEge677BD2GISF+6tB4pzcQgJLGKUmDN/CxOE08gksf7FcSaQKjYBLYn9L26A
	dYsImEvsWvoTrINZYCejxP7bixhBEsICkRItD76wgNgsAqoSfYfPMoPYvAKuEmc7TjFDrJOT
	+LDnEdhqTgE3iaOPZ4MNFQKq+dDziH0CI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMGR9Ex6B+OqBotDjAIcjEo8vCv2aAYLsSaWFVfmHmKU4GBWEuG1dtcKFuJNSaysSi3Kjy8q
	zUktPsSYDHTVRGYp0eR8YJTnlcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1
	CGYLEwenVAOj5z6/2Fcrt4f8kFMNs4ubayEXnrB1C9OP1S/klNUXfH601SFTZU/azbw2zy8e
	pleeZk+YfytG4WWd2xzmef/7jG7xPQiIX3DC66lj4Kk1v2S0zjr+cdjV3rh+xYyvBxTP/Fu5
	xir8P/tRHpm5gZUz+JtKLkUdtazd8c256WMUS2KlyJH8Y+UdSizFGYmGWsxFxYkAe9FkFegC	AAA=
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

