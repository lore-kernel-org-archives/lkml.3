Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaL3Fpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:45:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40210 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaL3Fpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:45:33 -0500
X-AuditID: cbfee68f-f791c6d000004834-1f-54a23bfbcdb9
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH] mfd: wm8994: use PLATFORM_DEVID_AUTO for
 regulator devs creation to avoid conflicts
Date: Tue, 30 Dec 2014 14:45:20 +0900
Message-id: <1419918320-12693-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkSPe39aIQg/7T1hZXLh5ispj68Amb
	xb8pN9gtdv29z2hx/+tRRotvVzqYLC7vmsNmsfztfzaL092sDpweGz43sXnsnHWX3WPTqk42
	jzvX9rB5zDsZ6PFy4m82j74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL4MqYuvEOc8Fzzooja+Yy
	NTB+ZO9i5OSQEDCReLf1GxuELSZx4d56IJuLQ0hgKaPEzQOHmGCK7s56wgSRmM4osfHfF1YI
	Zw6TxPNrp1hAqtgENCS+f97MDGKLCDhKPF66D6ybWeAYo8TsxkIQW1igWOJRxwpGEJtFQFWi
	adcaoEEcHLwCbhLzWlkhlmlL7GuYCXaFhMAydon2ZXfZIOoFJL5NPsQCUi8hICux6QAzRL2k
	xMEVN1gmMAouYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREY5Kf/PevfwXj3gPUhRgEO
	RiUe3g3vF4YIsSaWFVfmHmI0BdowkVlKNDkfGEt5JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgZGcq5JjxzHdu1rTmTKZMp/lNU+w2r3DY+3d6+Uqp
	/w9SsyUUD6014e47vqfzfNfrozUtgfyKH7ceKClsKC142ntWVIXFlylsDcOOKp3Uqx8eCR7b
	uPKZS3+CZXrJsY+za3R9eoRZtedW8NxhydNrfZmtte5vdvyBde6tN1ofBSrZqf1OvnlEiaU4
	I9FQi7moOBEA19KOZW0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jQd3f1otCDPbMNbK4cvEQk8XUh0/Y
	LP5NucFusevvfUaL+1+PMlp8u9LBZHF51xw2i+Vv/7NZnO5mdeD02PC5ic1j56y77B6bVnWy
	edy5tofNY97JQI+XE3+zefRtWcXo8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjKkb7zAXPOesOLJmLlMD40f2LkZODgkBE4m7s54wQdhiEhfurWfrYuTiEBKY
	ziix8d8XVghnDpPE82unWECq2AQ0JL5/3swMYosIOEo8XroPrJtZ4BijxOzGQhBbWKBY4lHH
	CkYQm0VAVaJp1xqgQRwcvAJuEvNaWSGWaUvsa5jJNoGRewEjwypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4Bh6Jr2DcVWDxSFGAQ5GJR7eDe8XhgixJpYVV+YeYpTgYFYS4W00WBQixJuS
	WFmVWpQfX1Sak1p8iNEUaPlEZinR5HxgfOeVxBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5ak
	ZqemFqQWwfQxcXBKNTDO8Il4xph8dFLps2075vzVma9yWdunR+POhq6MvF2Zv87ZeNoVbTO8
	/DBEZmfA9N83s/9c45MxcuLbbNF3Jq07cfKPtSuflJtzPuXXfR9Sa3BPQ4tnvcbW+5Z3BV2+
	zjTh3jZpnpWuUpmjWM+Wm48Y0yZx21/Q8JxXfz5M/Irw3JgXmo8YP3EqsRRnJBpqMRcVJwIA
	tyYQ/rcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit: 6e3f62f0793e ("mfd: core: Fix platform-device id generation")
We must set the id base when register a duplicate name of mfd_cell.
but, if we use PLATFORM_DEVID_AUTO flag, cell ids are automatically
allocated and managed without cell id setting.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/wm8994-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index e6fab94..0505e45 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -36,12 +36,10 @@
 static const struct mfd_cell wm8994_regulator_devs[] = {
 	{
 		.name = "wm8994-ldo",
-		.id = 1,
 		.pm_runtime_no_callbacks = true,
 	},
 	{
 		.name = "wm8994-ldo",
-		.id = 2,
 		.pm_runtime_no_callbacks = true,
 	},
 };
@@ -344,7 +342,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	dev_set_drvdata(wm8994->dev, wm8994);
 
 	/* Add the on-chip regulators first for bootstrapping */
-	ret = mfd_add_devices(wm8994->dev, -1,
+	ret = mfd_add_devices(wm8994->dev, PLATFORM_DEVID_AUTO,
 			      wm8994_regulator_devs,
 			      ARRAY_SIZE(wm8994_regulator_devs),
 			      NULL, 0, NULL);
-- 
2.0.0.390.gcb682f8

