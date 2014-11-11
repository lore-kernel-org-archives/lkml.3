Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaKKQOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:14:14 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58782 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaKKQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:14:13 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, tiwai@suse.de, lgirdwood@gmail.com,
        broonie@linaro.org, perex@perex.cz
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] sound: soc: Fix warning while make xmldocs caused by pcm_native.c
Date: Wed, 12 Nov 2014 01:13:56 +0900
Message-Id: <1415722436-20053-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following warning.

Warning(.//sound/core/pcm_native.c:1112): Excess function parameter
'state' description in 'snd_pcm_stop_xrun'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/core/pcm_native.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index a3d1221..095d957 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1101,7 +1101,6 @@ int snd_pcm_drain_done(struct snd_pcm_substream *substream)
 /**
  * snd_pcm_stop_xrun - stop the running streams as XRUN
  * @substream: the PCM substream instance
- * @state: PCM state after stopping the stream
  *
  * This stops the given running substream (and all linked substreams) as XRUN.
  * Unlike snd_pcm_stop(), this function takes the substream lock by itself.
-- 
2.2.0.rc1

