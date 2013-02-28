Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab3B1WPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:15:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51331 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759748Ab3B1WPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:15:16 -0500
Message-ID: <1362089715.1928.22.camel@joe-AO722>
Subject: [PULL REQUEST staging-next] staging: vt6655: Whitespace cleanups
 only
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>
Cc: devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org
Date: Thu, 28 Feb 2013 14:15:15 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a nearly completely scripted pass to convert
the vt6655 sources to something more kernel like.

It's too large to post, ~2.3Mb.

No lines added or removed.

git diff -w shows no differences.
Compilation allyesconfig, allmodconfig shows no
object/module differences.

---

The following changes since commit 8b5628ab83b671f96ac9f174c1bd51c92589fc82:

  Merge tag 'virt' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-02-21 15:40:16 -0800)

are available in the git repository at:


  git://repo.or.cz/linux-2.6/trivial-mods.git 20130228_vt6655

for you to fetch changes up to ac8672419217a49c966d2458498c082d2572cf27:

  staging: vt6655: Whitespace cleanups (2013-02-28 13:48:42 -0800)

----------------------------------------------------------------
Joe Perches (1):
      staging: vt6655: Whitespace cleanups

 drivers/staging/vt6655/80211hdr.h    |   44 +-
 drivers/staging/vt6655/80211mgr.c    | 1122 ++---
 drivers/staging/vt6655/80211mgr.h    |  640 +--
 drivers/staging/vt6655/IEEE11h.c     |  104 +-
 drivers/staging/vt6655/IEEE11h.h     |    6 +-
 drivers/staging/vt6655/aes_ccmp.c    |  566 +--
 drivers/staging/vt6655/baseband.c    | 4810 ++++++++++----------
 drivers/staging/vt6655/baseband.h    |   56 +-
 drivers/staging/vt6655/bssdb.c       | 2648 +++++------
 drivers/staging/vt6655/bssdb.h       |  396 +-
 drivers/staging/vt6655/card.c        | 2792 ++++++------
 drivers/staging/vt6655/card.h        |  130 +-
 drivers/staging/vt6655/channel.c     |  730 +--
 drivers/staging/vt6655/channel.h     |   14 +-
 drivers/staging/vt6655/country.h     |  238 +-
 drivers/staging/vt6655/datarate.c    |  456 +-
 drivers/staging/vt6655/datarate.h    |   42 +-
 drivers/staging/vt6655/desc.h        |  482 +-
 drivers/staging/vt6655/device.h      |  902 ++--
 drivers/staging/vt6655/device_cfg.h  |   24 +-
 drivers/staging/vt6655/device_main.c | 4882 ++++++++++----------
 drivers/staging/vt6655/dpc.c         | 2440 +++++-----
 drivers/staging/vt6655/dpc.h         |    8 +-
 drivers/staging/vt6655/hostap.c      |  666 +--
 drivers/staging/vt6655/iocmd.h       |  200 +-
 drivers/staging/vt6655/ioctl.c       |   16 +-
 drivers/staging/vt6655/ioctl.h       |   12 +-
 drivers/staging/vt6655/iowpa.h       |   42 +-
 drivers/staging/vt6655/iwctl.c       | 2170 ++++-----
 drivers/staging/vt6655/iwctl.h       |  200 +-
 drivers/staging/vt6655/key.c         | 1160 ++---
 drivers/staging/vt6655/key.h         |  168 +-
 drivers/staging/vt6655/mac.c         | 1632 +++----
 drivers/staging/vt6655/mac.h         |  836 ++--
 drivers/staging/vt6655/mib.c         |  698 +--
 drivers/staging/vt6655/mib.h         |  502 +--
 drivers/staging/vt6655/michael.c     |  166 +-
 drivers/staging/vt6655/michael.h     |    6 +-
 drivers/staging/vt6655/power.c       |  468 +-
 drivers/staging/vt6655/power.h       |   30 +-
 drivers/staging/vt6655/rc4.c         |   78 +-
 drivers/staging/vt6655/rc4.h         |    6 +-
 drivers/staging/vt6655/rf.c          | 1456 +++---
 drivers/staging/vt6655/rf.h          |   22 +-
 drivers/staging/vt6655/rxtx.c        | 5652 +++++++++++------------
 drivers/staging/vt6655/rxtx.h        |   52 +-
 drivers/staging/vt6655/srom.c        |  254 +-
 drivers/staging/vt6655/srom.h        |   58 +-
 drivers/staging/vt6655/tcrc.c        |  156 +-
 drivers/staging/vt6655/tether.c      |   46 +-
 drivers/staging/vt6655/tether.h      |   34 +-
 drivers/staging/vt6655/tkip.c        |  328 +-
 drivers/staging/vt6655/tkip.h        |   12 +-
 drivers/staging/vt6655/ttype.h       |   12 +-
 drivers/staging/vt6655/upc.h         |  136 +-
 drivers/staging/vt6655/vntwifi.c     |  906 ++--
 drivers/staging/vt6655/vntwifi.h     |  258 +-
 drivers/staging/vt6655/wcmd.c        | 1734 ++++----
 drivers/staging/vt6655/wcmd.h        |  108 +-
 drivers/staging/vt6655/wctl.c        |  246 +-
 drivers/staging/vt6655/wctl.h        |   70 +-
 drivers/staging/vt6655/wmgr.c        | 8154 +++++++++++++++++-----------------
 drivers/staging/vt6655/wmgr.h        |  514 +--
 drivers/staging/vt6655/wpa.c         |  334 +-
 drivers/staging/vt6655/wpa.h         |   22 +-
 drivers/staging/vt6655/wpa2.c        |  504 +--
 drivers/staging/vt6655/wpa2.h        |   28 +-
 drivers/staging/vt6655/wpactl.c      |  868 ++--
 drivers/staging/vt6655/wpactl.h      |    2 +-
 drivers/staging/vt6655/wroute.c      |  256 +-
 drivers/staging/vt6655/wroute.h      |    2 +-
 71 files changed, 27406 insertions(+), 27406 deletions(-)


