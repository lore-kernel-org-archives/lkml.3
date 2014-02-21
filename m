Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaBUPeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:34:19 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:60619 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbaBUPeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:34:18 -0500
X-Mailbox-Line: From c8340c624ab7ec38700523ce4c70b54db92d21e9 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1392995566.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 21 Feb 2014 16:12:46 +0100
Subject: [PATCH 0/4] ASoC: simple-card: DT fix and multi DAI links extension
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        devicetree@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes a small problem about node device locks and also
extends the simple card driver to handle many DAI links as this exists
in the Cubox audio subsystem.

Jean-Francois Moine (4):
  ASoC: simple-card: Fix device node locks
  ASoC: simple-card: dynamically allocate the DAI link array
  ASoC: simple-card: accept many DAI links
  ASoC: simple-card: add DT documentation for multi-DAI links

 .../devicetree/bindings/sound/simple-card.txt      |  34 ++++-
 sound/soc/generic/simple-card.c                    | 148 +++++++++++++++------
 2 files changed, 137 insertions(+), 45 deletions(-)

-- 
1.9.0

