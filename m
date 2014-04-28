Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaD1OHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:07:50 -0400
Received: from ring0.de ([5.45.105.125]:51809 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbaD1OHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:07:43 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCHv2 2/9] ASoC: omap: rx51: Add module alias
Date: Mon, 28 Apr 2014 16:07:20 +0200
Message-Id: <1398694047-28596-3-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add module alias to support driver autoloading.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 1a3f05c..55713d0 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -421,3 +421,4 @@ module_exit(rx51_soc_exit);
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("ALSA SoC Nokia RX-51");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rx51-audio");
-- 
1.9.2

