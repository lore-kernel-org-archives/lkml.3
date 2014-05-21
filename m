Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaEUDY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:24:28 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48866 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaEUDY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:24:27 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, kgene.kim@samsung.com
Subject: [PATCH 0/4] ASoC: samsung: Add devres APIs
Date: Wed, 21 May 2014 08:52:16 +0530
Message-Id: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding devres APIs to various files in sound/soc/samsung saves
us close to 150 lines of code.

The patches are based on next-20140519 and have been build tested.

Tushar Behera (4):
  ASoC: samsung: Use devm_snd_soc_register_card
  ASoC: samsung: Use devm_snd_soc_register_platform
  ASoC: samsung: Use devm_snd_soc_register_component
  ASoC: samsung: Add devm_clk_get to pcm.c

 sound/soc/samsung/ac97.c           |    9 ++-------
 sound/soc/samsung/bells.c          |   16 +++-------------
 sound/soc/samsung/dma.c            |    8 +-------
 sound/soc/samsung/dma.h            |    1 -
 sound/soc/samsung/dmaengine.c      |   13 ++++---------
 sound/soc/samsung/goni_wm8994.c    |    9 +++------
 sound/soc/samsung/i2s.c            |    2 --
 sound/soc/samsung/idma.c           |    9 +--------
 sound/soc/samsung/littlemill.c     |   18 +++---------------
 sound/soc/samsung/lowland.c        |   18 +++---------------
 sound/soc/samsung/pcm.c            |   17 ++++-------------
 sound/soc/samsung/s3c-i2s-v2.c     |    2 +-
 sound/soc/samsung/s3c2412-i2s.c    |   15 +--------------
 sound/soc/samsung/s3c24xx-i2s.c    |   19 +++----------------
 sound/soc/samsung/smdk_wm8580pcm.c |   15 +++------------
 sound/soc/samsung/smdk_wm8994pcm.c |   15 +++------------
 sound/soc/samsung/spdif.c          |   11 +++--------
 sound/soc/samsung/speyside.c       |   18 +++---------------
 sound/soc/samsung/tobermory.c      |   18 +++---------------
 19 files changed, 44 insertions(+), 189 deletions(-)

-- 
1.7.9.5

