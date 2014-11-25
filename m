Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaKYMfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:35:30 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:30693 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbaKYMf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:35:29 -0500
X-Mailbox-Line: From f093539970f62dbf319a7f7fee6360e05c32a1de Mon Sep 17 00:00:00 2001
Message-Id: <cover.1416918909.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 25 Nov 2014 13:35:09 +0100
Subject: [PATCH v5 0/4] ASoC: simple-card: Add multi-CODEC support
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds multi-CODEC support to the simple card.

v5: accept only "sound-dai" as the dai link property (Arnd Bergmann)
v4: (Mark Brown)
	- document the new core function
	- calculation of the number of codecs moved to the core function
	- split the patch about simple-card.c
	- less code changes
	- remove the cast of pointers
	- less changes in the DT binding example 2
v3: rebase on broonie git 2014/11/03
v2: accept list of CODECs in 'sound-dais' (Benoit Cousson)

Jean-Francois Moine (4):
  ASoC: core: add multi-codec support in DT
  ASoC: simple-card: Remove useless function argument
  ASoC: simple-card: add multi-CODECs in DT
  ASoC: simple-card: Remove useless check

 .../devicetree/bindings/sound/simple-card.txt      |  18 +---
 include/sound/soc.h                                |   3 +
 sound/soc/generic/simple-card.c                    |  87 ++++++++--------
 sound/soc/soc-core.c                               | 110 ++++++++++++++++++---
 4 files changed, 149 insertions(+), 69 deletions(-)

-- 
2.1.3

