Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3CSV6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:58:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51222 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753868Ab3CSV6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:58:44 -0400
Message-ID: <1363730323.16270.11.camel@joe-AO722>
Subject: [PATCH] sound: max98090: Remove executable bit
From: Joe Perches <joe@perches.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 14:58:43 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Source files shouldn't have the executable bit set.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/sound/max98090.h    | 0
 sound/soc/codecs/max98090.c | 0
 sound/soc/codecs/max98090.h | 0
 3 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/include/sound/max98090.h b/include/sound/max98090.h
old mode 100755
new mode 100644
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
old mode 100755
new mode 100644
diff --git a/sound/soc/codecs/max98090.h b/sound/soc/codecs/max98090.h
old mode 100755
new mode 100644


