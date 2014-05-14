Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaENDVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:21:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60412 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaENDVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:21:04 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: broonie@kernel.org
Subject: [PATCH] ASoC: samsung: Add missing pm ops for Snow sound card driver
Date: Wed, 14 May 2014 08:49:06 +0530
Message-Id: <1400037546-20395-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding missing pm ops so that audio playback works across
suspend and resume cycle.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/samsung/snow.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 0fa89a4..014c177 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -111,6 +111,7 @@ static struct platform_driver snow_driver = {
 	.driver = {
 		.name = "snow-audio",
 		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
 		.of_match_table = snow_of_match,
 	},
 	.probe = snow_probe,
-- 
1.7.9.5

