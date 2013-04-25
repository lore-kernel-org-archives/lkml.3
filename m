Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3DYNNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:13:41 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:57357 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3DYNNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:13:38 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net
Cc: broonie@kernel.org, perex@perex.cz, tiwai@suse.de, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH v2 0/3] ASoC: Add devicetree support for spdif dummy codecs.
Date: Thu, 25 Apr 2013 15:13:11 +0200
Message-Id: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes from v1 (for patch 2 and 3):
- add prefix linux for compatible property (for both tx and rx)
- rename spdif_transceiver.c to spdif_transmitter.c
- add bindings documentation

Marek Belisko (3):
  ASoC: spdif_transceiver: Change driver filename to
    spdif_transmitter.c.
  ASoC: spdif_transmitter: Add DT support.
  ASoC: spdif_receiver: Add DT support.

 .../devicetree/bindings/sound/spdif-receiver.txt   |   10 ++++++++++
 .../bindings/sound/spdif-transmitter.txt           |   10 ++++++++++
 sound/soc/codecs/Makefile                          |    2 +-
 sound/soc/codecs/spdif_receiver.c                  |   10 ++++++++++
 .../{spdif_transciever.c => spdif_transmitter.c}   |   10 ++++++++++
 5 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/sound/spdif-receiver.txt
 create mode 100644 Documentation/devicetree/bindings/sound/spdif-transmitter.txt
 rename sound/soc/codecs/{spdif_transciever.c => spdif_transmitter.c} (88%)

-- 
1.7.9.5

