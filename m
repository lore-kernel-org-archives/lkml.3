Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab3LFSZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:25:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab3LFSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:25:10 -0500
Date: Fri, 6 Dec 2013 10:25:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc fixes for 3.13-rc3
Message-ID: <20131206182509.GA30234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.13-rc3

for you to fetch changes up to 76a9635979e543f04a5885198e68ff28e3311b67:

  mei: add 9 series PCH mei device ids (2013-12-05 09:48:23 -0800)

----------------------------------------------------------------
Char/Misc driver fixes for 3.13-rc3

Nothing huge, just a few small bugfixes for problems reported, and a device id
update.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Ashutosh Dixit (4):
      misc: mic: Bug fix for sysfs poll usage.
      misc: mic: Fix user space namespace pollution from mic_common.h.
      misc: mic: Fix endianness issues.
      misc: mic: Suppress memory space sparse warnings

Charles Keepax (1):
      extcon: arizona: Get pdata from arizona structure not device

Greg Kroah-Hartman (1):
      Merge tag 'extcon-linus-for-3.13-rc2' of git://git.kernel.org/.../chanwoo/extcon into char-misc-linus

Sebastian Reichel (1):
      MAINTAINERS: add HSI subsystem

Sudeep Dutt (2):
      misc: mic: Change mic_notify(...) to return true.
      misc: mic: Minor bug fix in 'retry' loops.

Tomas Winkler (1):
      mei: add 9 series PCH mei device ids

Wang, Xiaoming (1):
      extcon: remove freed groups caused the panic or warning in unregister flow

 CREDITS                            |  5 +++++
 Documentation/mic/mpssd/mpssd.c    | 18 +++++++++++------
 MAINTAINERS                        |  8 ++++++++
 drivers/char/i8k.c                 |  7 +++++++
 drivers/extcon/extcon-arizona.c    |  4 +---
 drivers/extcon/extcon-class.c      |  3 ++-
 drivers/misc/mei/hw-me-regs.h      |  5 ++++-
 drivers/misc/mei/pci-me.c          |  4 +++-
 drivers/misc/mic/card/mic_virtio.c | 33 +++++++++++++++++--------------
 drivers/misc/mic/card/mic_virtio.h |  7 +++----
 drivers/misc/mic/host/mic_boot.c   |  2 +-
 drivers/misc/mic/host/mic_virtio.c | 30 ++++++++++++++--------------
 drivers/misc/mic/host/mic_x100.c   |  4 ++--
 include/uapi/linux/mic_common.h    | 40 +++++++++++++++-----------------------
 14 files changed, 97 insertions(+), 73 deletions(-)
