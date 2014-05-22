Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaEVJTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:19:20 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47801 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaEVJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:19:17 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Subject: [PATCH 0/2] ASoC: max98090/max98095: Add master clock handing
Date: Thu, 22 May 2014 14:47:06 +0530
Message-Id: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These CODECs are used on Snow/Peach-pit boards and the master clock
needs to be set at 24MHz.

Adding support in respective codec drivers so that we can update the
master clock frequency from sound card driver through set_sysclk.

These patches are prepared as per review comments on following patch.
[PATCH] ASoC: samsung: Add 'mclk' handling for Snow sound-card driver
https://lkml.org/lkml/2014/5/20/4

Tushar Behera (2):
  ASoC: max98090: Add master clock handling
  ASoC: max98095: Add master clock handling

 .../devicetree/bindings/sound/max98090.txt         |    6 ++++++
 .../devicetree/bindings/sound/max98095.txt         |    6 ++++++
 sound/soc/codecs/max98090.c                        |   13 +++++++++++++
 sound/soc/codecs/max98090.h                        |    1 +
 sound/soc/codecs/max98095.c                        |   14 ++++++++++++++
 5 files changed, 40 insertions(+)

-- 
1.7.9.5

