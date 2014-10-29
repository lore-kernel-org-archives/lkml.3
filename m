Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbaJ2OCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:02:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801AbaJ2OCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:02:00 -0400
Date: Wed, 29 Oct 2014 15:01:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1410291457540.20256@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive

- workarounds for a couple of misbehaving Elan Touchscreens, by Adel 
  Gadllah
- fix for TransducerSerialNumber field implementation, by Jason Gerecke
- a couple of new HID usages (added by HUT), by Olivier Gay

Thanks.

----------------------------------------------------------------
Adel Gadllah (2):
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Jason Gerecke (1):
      HID: input: Fix TransducerSerialNumber implementation

Olivier Gay (1):
      HID: add keyboard input assist hid usages

 drivers/hid/hid-debug.c         |  6 ++++++
 drivers/hid/hid-ids.h           |  2 ++
 drivers/hid/hid-input.c         | 12 +++++++++++-
 drivers/hid/usbhid/hid-quirks.c |  2 ++
 include/uapi/linux/input.h      |  7 +++++++
 5 files changed, 28 insertions(+), 1 deletion(-)

-- 
Jiri Kosina
SUSE Labs
