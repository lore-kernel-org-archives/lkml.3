Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab3EWQQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab3EWQQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:16:01 -0400
Date: Thu, 23 May 2013 09:16:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.10-rc3
Message-ID: <20130523161600.GA14517@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.10-rc2

for you to fetch changes up to b5325a02aa84c794cf520d6d68cae4b150988a32:

  ttyprintk: Fix NULL pointer deref by setting tty_port ops after initializing port (2013-05-21 10:13:23 -0700)

----------------------------------------------------------------
char/misc driver fixes for 3.10-rc2

Here are some small char/misc driver fixes for 3.10-rc2.

Nothing major here, just a number of fixes for things that people have
reported, and a MAINTAINERS update for the recent changes for the hyperv
files that went into 3.10-rc1.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Darrick J. Wong (1):
      ttyprintk: Fix NULL pointer deref by setting tty_port ops after initializing port

Geert Uytterhoeven (1):
      uio: UIO_DMEM_GENIRQ should depend on HAS_DMA

Haiyang Zhang (1):
      MAINTAINERS: update Hyper-V file list

Jonathan Corbet (1):
      dummy-irq: require the user to specify an IRQ number

K. Y. Srinivasan (1):
      Drivers: hv: Fix a bug in get_vp_index()

Samuel Ortiz (1):
      mei: bus: Reset event_cb when disabling a device

Tomas Winkler (1):
      mei: fix out of array access to me clients array

salina@us.ibm.com (1):
      Char: lp, protect LPGETSTATUS with port_mutex

 MAINTAINERS               |  9 ++++++++-
 drivers/char/lp.c         |  3 +++
 drivers/char/ttyprintk.c  |  2 +-
 drivers/hv/channel_mgmt.c |  2 +-
 drivers/misc/dummy-irq.c  |  6 +++++-
 drivers/misc/mei/bus.c    |  2 ++
 drivers/misc/mei/main.c   | 17 ++++++++---------
 drivers/uio/Kconfig       |  1 +
 8 files changed, 29 insertions(+), 13 deletions(-)
