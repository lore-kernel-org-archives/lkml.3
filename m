Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbbA2LWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:22:12 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:60101 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbbA2LWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:22:09 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ASoC: pcm512x: Fixups for the Clock master modes series
Date: Thu, 29 Jan 2015 12:21:54 +0100
Message-Id: <1422530516-21779-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

These fixups can either be squashed in with 5/7 from the Clock master mode
series, or they can be added on top of the current topic/pcm512x. Sorry for
the trouble.

I can squash them, and resend the Clock master modes series if that helps.
Let me know how you'd like it.

Cheers,
Peter

Peter Rosin (2):
  ASoC: pcm512x: Fixup warning splat
  ASoC: pcm512x: Use the correct range constraints for S24_LE

 sound/soc/codecs/pcm512x.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

-- 
1.7.10.4

