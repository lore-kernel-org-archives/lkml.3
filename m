Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3EXKj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:39:26 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33936 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3EXKjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:39:25 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/6] More code cleanup for ASoC ux500
Date: Fri, 24 May 2013 12:39:14 +0200
Message-Id: <1369391960-27320-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

this series contains more various code cleanup patches that I put
together while working on other stuff this drivers.

The first patch is actually a resend, as Linus Walleij agreed to drop
that code in the original thread (https://lkml.org/lkml/2013/5/17/487).

The others are just a bunch of sparse fixes and generic code cleanup and
dead code removal.

Thanks,
Fabio


Fabio Baltieri (6):
  ASoC: ux500: Drop pinctrl sleep support
  ASoC: ab8500-codec: Move codec ops on a separate structure
  ASoC: ux500: Drop dangling struct i2s_controller
  ASoC: ux500: Drop unused code from msp headers
  ASoC: ux500: Add missing mop500_ab8500.h include
  ASoC: ux500: Drop redundant msp id enumerations

 sound/soc/codecs/ab8500-codec.c | 19 ++++-------
 sound/soc/ux500/mop500_ab8500.c |  1 +
 sound/soc/ux500/ux500_msp_dai.h |  2 --
 sound/soc/ux500/ux500_msp_i2s.c | 75 ++---------------------------------------
 sound/soc/ux500/ux500_msp_i2s.h | 59 ++------------------------------
 5 files changed, 12 insertions(+), 144 deletions(-)

-- 
1.8.2

