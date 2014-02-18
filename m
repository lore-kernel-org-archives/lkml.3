Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaBRXKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:10:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaBRWqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 14/32] ALSA: usb-audio: Add missing kconfig dependecy
Date: Tue, 18 Feb 2014 14:47:14 -0800
Message-Id: <20140218224500.508123551@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4fa71c1550a857ff1dbfe9e99acc1f4cfec5f0d0 upstream.

The commit 44dcbbb1cd61 introduced the usage of bitreverse helpers but
forgot to add the dependency.  This patch adds the selection for
CONFIG_BITREVERSE.

Fixes: 44dcbbb1cd61 ('ALSA: snd-usb: add support for bit-reversed byte formats')
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

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


