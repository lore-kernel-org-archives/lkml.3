Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaIIPaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:30:08 -0400
Received: from mout.perfora.net ([74.208.4.197]:59841 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaIIPaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:30:05 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH 0/3] ASoC/ARM: tegra: apalis/colibri t30: sgtl5000 audio
Date: Tue,  9 Sep 2014 17:28:44 +0200
Message-Id: <cover.1410276224.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:gdpYROEXibqQ6BZr8p6soiRmj8kj52ddnp5p2bWegMS
 aJve0CC8yCxDegoHdmX6SbdE1sxDdde0tkge57IP2QEclMU8Gi
 5aALxrHqP/YUhnsJA9rRV3WM0U6bBlaFygDJSFRD1kKylLlhVF
 dlyPgXVSk4P/sMw1M3DhRHYhOFwJ4ElFbu7NihhIxWXQWvaZ/D
 qIfagX8GKa2Z2I237mCmbCWMw/Iv8PUKz8a1APzkTNnxHi/har
 PNiUw898CQcCkMJKlhgxFNp3i3YZ1hyApZVfcVRBqOA+c5OKGT
 e/erL2iTT/1FpndnMIudKiKKOQ3mqb4ZMdowbbhMPb5TXoy2OX
 J7DQWA4dpLPukGqz7dPE31279U47Cr0uX5tWUQgyHmsNPSgKip
 XZwufbIKP9r5Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds/integrates Freescale SGTL5000 analogue audio codec
support.

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

