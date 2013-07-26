Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3GZQze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:55:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3GZQzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:55:32 -0400
Date: Fri, 26 Jul 2013 09:55:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.11-rc3
Message-ID: <20130726165531.GA22443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.11-rc3

for you to fetch changes up to 9b0ee8cf70457520c144e944bcf8df2324bad880:

  HOWTO ja_JP sync (2013-07-24 22:06:34 -0700)

----------------------------------------------------------------
Char/Misc patches for 3.11-rc3

Here are some char/misc patches for 3.11-rc3.  It's pretty much just:
	- mei fixes
	- hyperv fixes
	- new ja_JP translation update
all tiny stuff, but fixes for issues people have reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Fernando Soto (1):
      Drivers: hv: vmbus: incorrect device name is printed when child device is unregistered

K. Y. Srinivasan (3):
      Drivers: hv: balloon: Fix a bug in the hot-add code
      Drivers: hv: balloon: Do not post pressure status if interrupted
      Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration

Tomas Winkler (4):
      mei: hbm: fix typo in error message
      mei: me: fix reset state machine
      mei: don't have to clean the state on power up
      mei: me: fix waiting for hw ready

Tsugikazu Shibata (1):
      HOWTO ja_JP sync

 Documentation/ja_JP/HOWTO | 44 ++++++++++++++++++++++----------------------
 drivers/hv/hv_balloon.c   | 21 +++++++++++++--------
 drivers/hv/vmbus_drv.c    |  8 ++++----
 drivers/misc/mei/hbm.c    |  2 +-
 drivers/misc/mei/hw-me.c  | 14 ++++++++++----
 drivers/misc/mei/init.c   |  3 ++-
 tools/hv/hv_kvp_daemon.c  |  5 +++--
 7 files changed, 55 insertions(+), 42 deletions(-)
