Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaH2K3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:29:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60314 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2K3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:29:08 -0400
X-AuditID: cbfee68f-f797f6d000001173-86-540055e2eeed
From: Alim Akhtar <alim.akhtar@samsung.com>
To: chris@printf.net, ulf.hansson@linaro.org
Cc: tgih.jun@samsung.com, jh80.chung@samsung.com, arnd@arndb.de,
        abrestic@chromium.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuvaraj.cd@samsung.com
Subject: [PATCH] mmc: dw_mmc: add support for ARM64
Date: Fri, 29 Aug 2014 15:54:51 +0530
Message-id: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t8zQ91HoQwhBq9mClisfP+X0eLvpGPs
	FhMub2e0uPGrjdXi8q45bBZH/vczWny4f5HZ4vjacIuzp8odOD1+/5rE6DG74SKLx51re9g8
	brxayOTRt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGXd2vmMqWMFWsf/8JsYGxqmsXYycHBIC
	JhKbGyYxQ9hiEhfurWfrYuTiEBJYxijx8PlTRpiix43nGSES0xkltm37BVU1gUli+4ousFFs
	AtoSd6dvYepi5OAQEdCRuPI+HCTMLLCaUeLE8joQW1jAWOJA216wbSwCqhJXZ/4AW8Ar4C7x
	7+AKZpBWCQEFiTmTbEDGSwhMZ5c48Oc1C0S9gMS3yYdYIGpkJTYdgDpaUuLgihssExgFFzAy
	rGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQICef+HYx3D1gfYhTgYFTi4e04+T9YiDWxrLgy
	9xCjKdCGicxSosn5wKjJK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDY0pM9a8Fv191XN0QsPSHpTjX1pVs87MOF3koXcrTWDiN8Z/zvGiGVSXHE1Rc
	dv66f3Xt1m2Ld66cOMX45q2ALYpNn4wFrc+pFZWcvjNhCo9CRWCu5rGjAkpHNt+9fMhcVbHM
	cS9D8XRlo4ybD394JbH96PIu+Hr+//JQp7tsNrU7bixS3T/D+bUSS3FGoqEWc1FxIgDZFvgo
	YgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jQd1HoQwhBr/aeCxWvv/LaPF30jF2
	iwmXtzNa3PjVxmpxedccNosj//sZLT7cv8hscXxtuMXZU+UOnB6/f01i9JjdcJHF4861PWwe
	N14tZPLo27KK0ePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBl3
	dr5jKljBVrH//CbGBsaprF2MnBwSAiYSjxvPM0LYYhIX7q1n62Lk4hASmM4osW3bLyhnApPE
	9hVdYB1sAtoSd6dvYepi5OAQEdCRuPI+HCTMLLCaUeLE8joQW1jAWOJA215mEJtFQFXi6swf
	YAt4Bdwl/h1cwQzSKiGgIDFnks0ERu4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj
	5ZnUDsaVDRaHGAU4GJV4eDtO/g8WYk0sK67MPcQowcGsJMJ73JAhRIg3JbGyKrUoP76oNCe1
	+BCjKdDyicxSosn5wEjOK4k3NDYxM7I0MrMwMjE3VxLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TB
	KdXAKOFxLva0j89pwQ3fJX2uqC4uenX79slJDbq3Miuu3M6X2HIsbrLreQ0/mU1rhF38xPhP
	lv/3uhBt6P3gy1/1p1MvS3xfuuHHhfI5E04ZTy/Z6HW+jPH/1jmJx9WEBe+VdN1j1jhsU3op
	4fW0Pr2Vc2ef13PSXnXu5Hn1S3vsF9xaIVNef/XJztlKLMUZiYZazEXFiQBALw4wrAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are upcoming ARM64 SoCs with dw_mmc host controller.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a43295c..72dd6c2 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -580,7 +580,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
 config MMC_DW
 	tristate "Synopsys DesignWare Memory Card Interface"
 	depends on HAS_DMA
-	depends on ARC || ARM || MIPS || COMPILE_TEST
+	depends on ARC || ARM || ARM64 || MIPS || COMPILE_TEST
 	help
 	  This selects support for the Synopsys DesignWare Mobile Storage IP
 	  block, this provides host support for SD and MMC interfaces, in both
-- 
1.7.10.4

