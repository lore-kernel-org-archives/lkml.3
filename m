Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaEXARC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:17:02 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51802 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaEXARA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:17:00 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [PATCH] ASoC: pxa: pxa-ssp: Terminate of match table
Date: Fri, 23 May 2014 17:16:49 -0700
Message-Id: <1400890613-5704-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure to terminate this match table can lead to boot failures
depending on where the compiler places the match table.

Cc: Daniel Mack <zonque@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 sound/soc/pxa/pxa-ssp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index a3119a00d8fa..dd35e7be1d8b 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -810,6 +810,7 @@ static const struct snd_soc_component_driver pxa_ssp_component = {
 #ifdef CONFIG_OF
 static const struct of_device_id pxa_ssp_of_ids[] = {
 	{ .compatible = "mrvl,pxa-ssp-dai" },
+	{}
 };
 #endif
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

