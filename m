Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbaBUMtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbaBUMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/121] ALSA: usb-audio: Add missing kconfig dependecy
Date: Fri, 21 Feb 2014 12:47:12 +0000
Message-Id: <1392986945-9693-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4fa71c1550a857ff1dbfe9e99acc1f4cfec5f0d0 upstream.

The commit 44dcbbb1cd61 introduced the usage of bitreverse helpers but
forgot to add the dependency.  This patch adds the selection for
CONFIG_BITREVERSE.

Fixes: 44dcbbb1cd61 ('ALSA: snd-usb: add support for bit-reversed byte formats')
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index de9408b..e05a86b 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -14,6 +14,7 @@ config SND_USB_AUDIO
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
+	select BITREVERSE
 	help
 	  Say Y here to include support for USB audio and USB MIDI
 	  devices.
-- 
1.9.0

