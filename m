Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3JGPvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:51:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3JGPvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:51:11 -0400
Date: Mon, 7 Oct 2013 17:51:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1310071749200.29701@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive

=====

- fix for hidraw reference counting regression, by Manoj Chourasia
- fix for minor number allocation for uhid, by David Herrmann
- other small unsorted fixes / device ID additions

=====

Anders F. U. Kiær (1):
      HID: add Holtek USB ID 04d9:a081 SHARKOON DarkGlider

David Herrmann (2):
      HID: uhid: allocate static minor
      HID: wiimote: fix FF deadlock

Manoj Chourasia (1):
      HID: hidraw: close underlying device at removal of last reader

Stefan Achatz (1):
      HID: roccat: Fix "cannot create duplicate filename" problems

 drivers/hid/Kconfig               |    1 +
 drivers/hid/hid-core.c            |    1 +
 drivers/hid/hid-holtek-mouse.c    |    4 +++
 drivers/hid/hid-ids.h             |    1 +
 drivers/hid/hid-roccat-kone.c     |    2 +-
 drivers/hid/hid-roccat-koneplus.c |    4 +-
 drivers/hid/hid-roccat-kovaplus.c |    4 +-
 drivers/hid/hid-roccat-pyra.c     |    4 +-
 drivers/hid/hid-wiimote-modules.c |   40 ++++++++++++++++++++++++++----------
 drivers/hid/hid-wiimote.h         |    4 ++-
 drivers/hid/hidraw.c              |   21 +++++++++++++------
 drivers/hid/uhid.c                |    3 +-
 include/linux/miscdevice.h        |    1 +
 13 files changed, 63 insertions(+), 27 deletions(-)

-- 
Jiri Kosina
SUSE Labs
