Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaGGOBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:01:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaGGOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:01:07 -0400
Date: Mon, 7 Jul 2014 16:01:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1407071559330.1655@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive a few tiny HID subsystem fixes for 3.16.

----------------------------------------------------------------
Chen Gang (1):
      HID: sensor-hub: introduce Kconfig dependency on IOMEM

Geert Uytterhoeven (1):
      HID: rmi: Protect PM-only functions by #ifdef CONFIG_PM

Jiri Kosina (1):
      HID: sensor-hub: make dyn_callback_lock IRQ-safe

Jiri Slaby (1):
      HID: sensor-hub: fix potential memory leak

John Sung (1):
      HID: usbhid: quirk for PM1610 and PM1640 Touchscreen.

Wen-chien Jesse Sung (1):
      HID: use multi input quirk for 22b9:2968

 drivers/hid/Kconfig             |  2 +-
 drivers/hid/hid-ids.h           |  3 +++
 drivers/hid/hid-rmi.c           |  2 ++
 drivers/hid/hid-sensor-hub.c    | 25 +++++++++++++++----------
 drivers/hid/usbhid/hid-quirks.c |  3 +++
 drivers/phy/Kconfig             |  1 +
 6 files changed, 25 insertions(+), 11 deletions(-)

-- 
Jiri Kosina
SUSE Labs
