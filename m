Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3GBJHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:07:10 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:3993 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab3GBJHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:07:08 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, richard.genoud@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 0/2] ASoC: atmel-pcm: use generic dmaengine framework
Date: Tue,  2 Jul 2013 17:04:07 +0800
Message-Id: <1372755849-19546-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch series is based on next-20130701

Bo Shen (2):
  ASoC: atmel_ssc_dai: move set dma data to startup callback
  ASoC: atmel-pcm: use generic dmaengine framework

 sound/soc/atmel/atmel-pcm-dma.c |  118 ++++++---------------------------------
 sound/soc/atmel/atmel_ssc_dai.c |   33 ++++++-----
 2 files changed, 32 insertions(+), 119 deletions(-)

-- 
1.7.9.5

