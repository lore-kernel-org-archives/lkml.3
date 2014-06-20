Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826AbaFTIGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:06:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54002 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338AbaFTIGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:06:41 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: dianders@chromium.org, kgene.kim@samsung.com, tiwai@suse.de,
        broonie@kernel.org, lgirdwood@gmail.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, trblinux@gmail.com
Subject: [PATCH 2/2] ASoC: samsung: Extend snow driver to support MAX98091
Date: Fri, 20 Jun 2014 13:33:16 +0530
Message-Id: <1403251396-17487-2-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403251396-17487-1-git-send-email-tushar.b@samsung.com>
References: <1403251396-17487-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peach-pi board has MAX98091 CODEC. Extend snow machine driver to support
this board.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 Documentation/devicetree/bindings/sound/snow.txt |    1 +
 sound/soc/samsung/snow.c                         |    1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/snow.txt b/Documentation/devicetree/bindings/sound/snow.txt
index 678b191..e0b7a82 100644
--- a/Documentation/devicetree/bindings/sound/snow.txt
+++ b/Documentation/devicetree/bindings/sound/snow.txt
@@ -3,6 +3,7 @@ Audio Binding for Snow boards
 Required properties:
 - compatible : Can be one of the following,
 			"google,snow-audio-max98090" or
+			"google,snow-audio-max98091" or
 			"google,snow-audio-max98095"
 - samsung,i2s-controller: The phandle of the Samsung I2S controller
 - samsung,audio-codec: The phandle of the audio codec
diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 014c177..8bbd348 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -103,6 +103,7 @@ static int snow_probe(struct platform_device *pdev)
 
 static const struct of_device_id snow_of_match[] = {
 	{ .compatible = "google,snow-audio-max98090", },
+	{ .compatible = "google,snow-audio-max98091", },
 	{ .compatible = "google,snow-audio-max98095", },
 	{},
 };
-- 
1.7.9.5

