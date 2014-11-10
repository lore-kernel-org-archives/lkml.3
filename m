Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaKJI0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:26:37 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:2721 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaKJI0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:26:36 -0500
X-Mailbox-Line: From 3b3dcd0172b0bdd0a661d65d697a73f837565309 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1415605716.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 10 Nov 2014 08:48:36 +0100
Subject: [PATCH v4 0/4] ASoC: simple-card: Add multi-CODEC support
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds multi-CODEC support to the simple card.

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

 .../devicetree/bindings/sound/simple-card.txt      |  20 ++--
 include/sound/soc.h                                |   3 +
 sound/soc/generic/simple-card.c                    |  87 ++++++++--------
 sound/soc/soc-core.c                               | 113 ++++++++++++++++++---
 4 files changed, 154 insertions(+), 69 deletions(-)

-- 
2.1.3

