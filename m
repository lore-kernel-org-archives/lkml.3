Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaLOPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:16:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaLOO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 020/168] ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow
Date: Mon, 15 Dec 2014 14:24:34 +0000
Message-Id: <1418653622-21105-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>

commit 62e6a3b6f4e1f9b96fa66ab1cdf2ffd8594df9e9 upstream.

This enables the snd_soc_snow module to be auto-loaded.

Signed-off-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/samsung/snow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/samsung/snow.c b/sound/soc/samsung/snow.c
index 014c177840ba..d9c6c8f82006 100644
--- a/sound/soc/samsung/snow.c
+++ b/sound/soc/samsung/snow.c
@@ -106,6 +106,7 @@ static const struct of_device_id snow_of_match[] = {
 	{ .compatible = "google,snow-audio-max98095", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, snow_of_match);
 
 static struct platform_driver snow_driver = {
 	.driver = {
-- 
2.1.3

