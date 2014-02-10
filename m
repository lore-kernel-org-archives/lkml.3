Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaBJGVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:21:45 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:8384 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaBJGVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:21:42 -0500
From: Bo Shen <voice.shen@atmel.com>
To: broonie@kernel.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-atm-general@lists.sourceforge.net,
        Richard Genoud <richard.genoud@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@linaro.org>, Jaroslav Kysela <perex@perex.cz>,
        netdev@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v3 0/2] ASoC: atmel_ssc_dai: add option to choose clock
Date: Mon, 10 Feb 2014 14:09:44 +0800
Message-Id: <1392012586-30790-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SSC work in slave mode, the clock can come from TK pin and also
can come from RK pin, this is hardware design decided. So, make it
available to choose where the clock from.

Changes in v3:
  - Move the property from card to ssc device
Series-changes: 2
  - using "-" replace "_" in binding document

Bo Shen (2):
  ASoC: atmel_ssc_dai: make option to choose clock
  Binding: atmel-ssc: add option to choose clock

 Documentation/devicetree/bindings/misc/atmel-ssc.txt |  8 ++++++++
 drivers/misc/atmel-ssc.c                             |  6 ++++++
 include/linux/atmel-ssc.h                            |  1 +
 sound/soc/atmel/atmel_ssc_dai.c                      | 13 +++++++++----
 4 files changed, 24 insertions(+), 4 deletions(-)

-- 
1.8.5.2

