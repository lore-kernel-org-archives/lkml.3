Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaCQKEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:04:37 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:31860 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaCQKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:04:18 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>, nicolas.ferre@atmel.com
Cc: Bo Shen <voice.shen@atmel.com>, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Andrew Victor <linux@maxim.org.za>,
        Pawel Moll <pawel.moll@arm.com>, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Wolfram Sang <wsa@the-dreams.de>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/8] ARM: at91: sama5d3: enable sound support
Date: Mon, 17 Mar 2014 17:45:33 +0800
Message-Id: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add sound support on sama5d3xek board.

This patch series based on the following patch set:
  clk: at91: better support for the PCKs
  http://comments.gmane.org/gmane.linux.kernel/1664477


Bo Shen (5):
  ARM: at91: sama5d3: add DMA property for SSC devices
  ARM: at91: sama5d3: disable sound by default
  ARM: at91: sama5d3: correct the sound compatible string
  ARM: at91: sama5d3: add the missing property
  ARM: at91: sama5d3: clock for ssc from rk pin

Boris BREZILLON (3):
  ASoC: atmel: support CCF based clks
  ASoC: atmel: document clock properties of the wm8904 driver
  ARM: at91/dt: add clock properties to the wm8904 codec node

 .../devicetree/bindings/sound/atmel-wm8904.txt     |  2 ++
 arch/arm/boot/dts/sama5d3.dtsi                     |  6 ++++++
 arch/arm/boot/dts/sama5d3xmb.dtsi                  | 11 +++++++++-
 sound/soc/atmel/atmel_wm8904.c                     | 25 +++++++++++-----------
 4 files changed, 31 insertions(+), 13 deletions(-)

-- 
1.8.5.2

