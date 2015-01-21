Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbbAUTcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:32:46 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:50826 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbbAUTci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:32:38 -0500
X-Mailbox-Line: From d0c66c2e2f200119f9990fa52a503b1a4af6238f Mon Sep 17 00:00:00 2001
Message-Id: <cover.1421868426.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Wed, 21 Jan 2015 20:27:06 +0100
Subject: [PATCH v2 0/3] ASoC: add audio card creation from graph of ports in DT
To: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a way to build audio cards from the description
of a graph of ports in a devicetree.

v2:
	- move the soc-core and dt-card from the patchset
		"ASoC: tda998x: add a codec to the HDMI transmitter"
	- add DT documentation (Mark Brown)

Jean-Francois Moine (3):
  ASoC: core: export snd_soc_get_dai_name
  Documentation: of: Document audio graph bindings
  ASoC: add generic dt-card support

 .../devicetree/bindings/sound/audio-interfaces.txt | 101 ++++++++
 include/sound/soc.h                                |   2 +
 sound/soc/generic/Kconfig                          |   2 +
 sound/soc/generic/Makefile                         |   2 +
 sound/soc/generic/dt-card.c                        | 275 +++++++++++++++++++++
 sound/soc/soc-core.c                               |   5 +-
 6 files changed, 385 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/audio-interfaces.txt
 create mode 100644 sound/soc/generic/dt-card.c

-- 
2.1.4

