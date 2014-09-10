Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaIJUz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:55:58 -0400
Received: from mout.perfora.net ([74.208.4.197]:64441 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaIJUz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:55:56 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 0/2] ASoC/ARM: tegra: apalis/colibri t30: sgtl5000 audio
Date: Wed, 10 Sep 2014 22:54:54 +0200
Message-Id: <cover.1410362950.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:Sy96VtYe393yPQnsnHQSxquexTr7VRxuqH4FwbMckC5
 cfNTGhQFT4COWwLDuI1AC8ZGQ0zd6zjvaeWydXwLYDAmMgtLt1
 n4R/NK7tF0aaj/VrZht5Ll0h88/1SAHCtzZXN+ZCBOL9YIbuKO
 YhivUr/nMcmh24AUFNeaMSAz5ov5x78prFDCGCsTM8tZl8rQ9X
 oV5p0+OU4p5Z9AT5D48iEyIm9b5haFFLzkjVWUk+5HnvWMFk3q
 96GXlsKhDfPX7mnsDdNKyFrbVgdEOiTFLZl4KUVY0rZfv9lasp
 WmoZROpGGZknN448R/CnHXdOCAvidPGE2+3fVKXmZlUsjS1ne2
 7NC51ty3HJFaeJIv8URrYt04YbypvXoRKxRjx9nDR
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds/integrates Freescale SGTL5000 analogue audio codec
support.

Changes in v2:
- Using simple-audio-card as suggested by Fabio.

Marcel Ziswiler (2):
  ARM: tegra: apalis/colibri t30: integrate audio support
  ARM: tegra: enable sgtl5000 audio

 arch/arm/boot/dts/tegra30-apalis.dtsi  | 65 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra30-colibri.dtsi | 65 ++++++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig       |  2 ++
 3 files changed, 132 insertions(+)

-- 
1.9.3

