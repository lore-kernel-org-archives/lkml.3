Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbaKMRwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:52:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59052 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933357AbaKMRwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:52:14 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, lgirdwood@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, linus.walleij@linaro.org, gnurou@gmail.com,
        broonie@kernel.org, tiwai@suse.de
Cc: perex@perex.cz, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 3/6] regulator: arizona-micsupp: Add support for WM8280/WM8281
Date: Thu, 13 Nov 2014 17:50:43 +0000
Message-Id: <1415901046-3391-4-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index ce9aca5..4ff55e1 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -245,6 +245,7 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	 */
 	switch (arizona->type) {
 	case WM5110:
+	case WM8280:
 		desc = &arizona_micsupp_ext;
 		micsupp->init_data = arizona_micsupp_ext_default;
 		break;
-- 
1.7.2.5

