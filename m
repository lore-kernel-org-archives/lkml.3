Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaGADWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 23:22:04 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:33817 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaGADWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 23:22:02 -0400
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Tue, 01 Jul 2014 10:20:18 +0800
From: Rongjun Ying <rongjun.ying@csr.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Barry Song <baohua@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <Workgroup.linux@csr.com>
CC: Rongjun Ying <rongjun.ying@csr.com>
Subject: [PATCH 0/2] ASoC: add CSR SiRFSoC audio USP interface driver
Date: Tue, 1 Jul 2014 10:18:52 +0800
Message-ID: <1404181134-21663-1-git-send-email-rongjun.ying@csr.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
X-Originating-IP: [10.125.12.180]
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the SiRF USP controller driver, this
driver uses the USP as I2S or DSP_A mode interface.

Rongjun Ying (2):
  ASoC: sirf: Add audio usp interface driver
  ASoC: sirf: Add device tree binding for the USP audio device

 .../devicetree/bindings/sound/sirf-usp.txt         |  27 ++
 sound/soc/sirf/Kconfig                             |   6 +
 sound/soc/sirf/Makefile                            |   2 +
 sound/soc/sirf/sirf-usp.c                          | 409 +++++++++++++++++++++
 sound/soc/sirf/sirf-usp.h                          | 293 +++++++++++++++
 5 files changed, 737 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/sirf-usp.txt
 create mode 100644 sound/soc/sirf/sirf-usp.c
 create mode 100644 sound/soc/sirf/sirf-usp.h

-- 
1.9.3



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.
