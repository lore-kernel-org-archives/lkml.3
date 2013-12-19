Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3LSPzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:55:31 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43583 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3LSPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 00/10] ASoC: ARM: ux500: Better prepare for full Device Tree
Date: Thu, 19 Dec 2013 15:54:57 +0000
Message-Id: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this moment in time the Ux500 ASoC driver obtains its DMA information
via AUXDATA platform data passing. To make the driver more independent
we have to start extracting it from the Device Tree. This patch-set goes
some way to ensure the ux500 Audio driver is ready for the switch over.

 arch/arm/mach-ux500/board-mop500-audio.c     |   8 +++----
 include/linux/platform_data/asoc-ux500-msp.h |   9 +-------
 sound/soc/codecs/ab8500-codec.c              |   4 ++--
 sound/soc/ux500/mop500.c                     |   2 ++
 sound/soc/ux500/ux500_msp_dai.c              | 146 +++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------
 sound/soc/ux500/ux500_msp_i2s.c              |  56 ++++++++++++++++++++++++++++++++------------
 sound/soc/ux500/ux500_msp_i2s.h              |   2 +-
 sound/soc/ux500/ux500_pcm.c                  |  50 ++++++++++++++++++++++++++--------------
 8 files changed, 144 insertions(+), 133 deletions(-)

