Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaHURnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:43:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaHURnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:43:53 -0400
Date: Thu, 21 Aug 2014 12:43:50 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1408211146110.23162@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive:



- fixes for a couple potential memory corruption problems (the HW would 
  have to be manufactured to be deliberately evil to trigger those) found 
  by Ben Hawkes
- fix for potential infinite loop when using sysfs interface of logitech
  driver, from Simon Wood
- a couple more simple driver fixes



Thanks.

----------------------------------------------------------------
Andrew Duggan (1):
      HID: rmi: print an error if F11 is not found instead of stopping the device

Himangi Saraogi (1):
      HID: hid-sensor-hub: use devm_ functions consistently

Jiri Kosina (3):
      HID: logitech: fix bounds checking on LED report size
      HID: logitech: perform bounds checking on device_id early enough
      HID: fix a couple of off-by-ones

Nikolai Kondrashov (2):
      HID: huion: Fail on parameter retrieval errors
      HID: huion: Use allocated buffer for DMA

Simon Wood (1):
      HID: logitech: Prevent possibility of infinite loop when using /sys interface

 drivers/hid/hid-cherry.c      |   2 +-
 drivers/hid/hid-huion.c       | 128 +++++++++++++++++++++++++-----------------
 drivers/hid/hid-kye.c         |   2 +-
 drivers/hid/hid-lg.c          |   4 +-
 drivers/hid/hid-lg4ff.c       |   4 +-
 drivers/hid/hid-logitech-dj.c |  15 +++--
 drivers/hid/hid-monterey.c    |   2 +-
 drivers/hid/hid-petalynx.c    |   2 +-
 drivers/hid/hid-rmi.c         |  13 +++--
 drivers/hid/hid-sensor-hub.c  |  33 ++++-------
 drivers/hid/hid-sunplus.c     |   2 +-
 11 files changed, 114 insertions(+), 93 deletions(-)

-- 
Jiri Kosina
SUSE Labs
