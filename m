Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbaJDAQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:16:23 -0400
Received: from mout.perfora.net ([74.208.4.196]:58391 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580AbaJDAQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:16:19 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 0/3] ASoC/ARM: tegra: apalis/colibri t30: sgtl5000 audio
Date: Sat,  4 Oct 2014 02:15:42 +0200
Message-Id: <cover.1412381377.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:wJMqPmKRecLu9Q/OoU+pbo+ys23iF46TeOyvMnwSTsj
 GCyXP/TWAX05Nn4H8Nz7h2N+N4+f7IgIxTDBPeoKjxgEjN6Maq
 0mcB895A+78kMQtAlEplQsMcjNV1vhVVcK+3RRZPYGid7UMzGU
 XjmHyFD63Sj08WEDGyLfkwp9T72FY6f8DFfr7KI6tyzGW6PKwB
 ZNmVml4LUD/l4zds0aQNEXp+CUg5W3inWFOoi6+wkmXMn2RCuO
 Nv45A/jpU6/mzfBHzcYytUDEaZ/8sYNCBxP6nszfd/83VZ/D8g
 hcyVCtPlOpYgINs31cdzmL3PTbIxIYYz/K48mfuLib3hrgUWR5
 1qwqJp+cY685JvH9+OTG8IISruDg59/aKNCvupnXb
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds/integrates Freescale SGTL5000 analogue audio codec
support.

Changes in v3:
- Revert to not using simple-audio-card being incompatible with tegra.
- Rebased to for-next.

Changes in v2:
- Using simple-audio-card as suggested by Fabio.

Marcel Ziswiler (3):
  ASoC: tegra: add tegra sgtl5000 machine driver
  ARM: tegra: apalis/colibri t30: integrate audio support
  ARM: tegra: enable sgtl5000 audio

 .../bindings/sound/nvidia,tegra-audio-sgtl5000.txt |  45 +++++
 arch/arm/boot/dts/tegra30-apalis.dtsi              |  49 +++++
 arch/arm/boot/dts/tegra30-colibri.dtsi             |  49 +++++
 arch/arm/configs/tegra_defconfig                   |   1 +
 sound/soc/tegra/Kconfig                            |  10 +
 sound/soc/tegra/Makefile                           |   2 +
 sound/soc/tegra/tegra_sgtl5000.c                   | 216 +++++++++++++++++++++
 7 files changed, 372 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/nvidia,tegra-audio-sgtl5000.txt
 create mode 100644 sound/soc/tegra/tegra_sgtl5000.c

-- 
1.9.3

