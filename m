Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3D3OKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:10:21 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47690 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128Ab3D3OKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:10:16 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH -next 0/3] mop500_ab8500 fixes
Date: Tue, 30 Apr 2013 16:09:51 +0200
Message-Id: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

these are small fixes to the mop500_ab8500 asoc driver, developed on top
of today's ASoC-next.

The first patch is actually non ab8500 specific, but as ab8500 seems to
be the only codec to use the SND_SOC_DAPM_CLOCK_SUPPLY widget I'm
posting it here anyway.

The other two patches sort out a mixup of card and codec controls in
mop500_ab8500.

Thanks,
Fabio


Fabio Baltieri (3):
  ASoC: dapm: use clk_prepare_enable and clk_disable_unprepare
  ASoC: ux500: move clock controls to ab8500-codec
  ASoC: ux500: register controls to card instead of codec

 sound/soc/codecs/ab8500-codec.c | 10 ++++++++++
 sound/soc/soc-dapm.c            |  4 ++--
 sound/soc/ux500/mop500_ab8500.c | 20 +++++---------------
 3 files changed, 17 insertions(+), 17 deletions(-)

-- 
1.8.2

