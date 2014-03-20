Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaCTDCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:02:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36123 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaCTC7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:59:24 -0400
X-AuditID: cbfee68f-b7f156d00000276c-f6-532a598b5fdc
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, t.figa@samsaung.com, b.zolnierkie@samsaung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 5/5] devfreq: exynos5: Add CONFIG_PM_OPP dependency to fix
 probe fail
Date: Thu, 20 Mar 2014 11:59:13 +0900
Message-id: <1395284353-22458-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkRLc7UivYYPEpJYuOnt8sFte/PGe1
	ONv0ht3i8q45bBYzzu9jsrjduILN4vGKt+wWN6fOZnLg8Fi85yWTx8/l29k9+rasYvT4vEku
	gCWKyyYlNSezLLVI3y6BK+P+ux72gilsFYsfnmFtYJzA2sXIySEhYCKx+NxTRghbTOLCvfVs
	ILaQwFJGicb30TA1f66cZe5i5AKKL2KU2H3hB5TTyCRxeMlmsA42AS2J/S9ugNkiAuYSu5b+
	ZAMpYhbYySix//YisBXCApESy95/BVvNIqAqMW/ZDLAGXgFXiS0LDkOdJCfxYc8jdhCbU8BN
	4ujj2VAnuUp86IGISwjMY5d4f0kMYo6AxLfJh1i6GDmA4rISmw4wQ5RIShxccYNlAqPwAkaG
	VYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBYX7637P+HYx3D1gfYkwGGjeRWUo0OR8YJ3kl
	8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVGwV0/w
	aFbROQ+mBSs+GU/M0DCRbLBv6E8z/LHqXbHLG41Gjo4N9cvm1p4t8LkgLH9i/qWH5VFGCg8m
	Xr+xN01C8p7y4oXxLdOvK37PeR827b8N15GaPtfEqy4sv3XykrdM8fGX01llcNrgh+gKNvV4
	XUkT64Vzj6zoX+fXKHyX0WGO+SW/uUosxRmJhlrMRcWJAIchelWJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd3uSK1gg/uTpS06en6zWFz/8pzV
	4mzTG3aLy7vmsFnMOL+PyeJ24wo2i8cr3rJb3Jw6m8mBw2PxnpdMHj+Xb2f36NuyitHj8ya5
	AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ99/1sBdMYatY/PAMawPj
	BNYuRk4OCQETiT9XzjJD2GISF+6tZ+ti5OIQEljEKLH7wg9mCKeRSeLwks1sIFVsAloS+1/c
	ALNFBMwldi39CdbBLLCTUWL/7UWMIAlhgUiJZe+/gq1gEVCVmLdsBlgDr4CrxJYFh6FWy0l8
	2POIHcTmFHCTOPp4NliNEFDNh55H7BMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CI6kZ9I7GFc1WBxiFOBgVOLhXbFHM1iINbGsuDL3EKMEB7OSCK+1u1awEG9KYmVValF+fFFp
	TmrxIcZkoKsmMkuJJucDozyvJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalF
	MFuYODilGhgV9vYqM7x5xc8qeFHm37QNnO/2XG+zaT3YV+ozX6Xuv9qk56xJ87NiytdXZzyc
	yqzQVi2VvrA9+/Dal3xtV7sTpymcKCryevju29kqodrFHQ66O3nY312IOmPoV9p2VimabRXX
	fx21X+rt2XV2H7fP0fz5PWG9aeu7GJbIHKnrb/c+PvjR6b8SS3FGoqEWc1FxIgCL2Nsq6AIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add CONFIG_PM_OPP dependecy to exynos5_bus driver
to fix probe fail. If CONFIG_PM_OPP is disabled, dev_pm_opp_find_freq_floor()
will always return ERR_PTR(-EINVAL) error.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index b2de2a1..c023c57 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -84,6 +84,7 @@ config ARM_EXYNOS5_BUS_DEVFREQ
 	depends on SOC_EXYNOS5250
 	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select PM_OPP
 	help
 	  This adds the DEVFREQ driver for Exynos5250 bus interface (vdd_int).
 	  It reads PPMU counters of memory controllers and adjusts the
-- 
1.8.0

