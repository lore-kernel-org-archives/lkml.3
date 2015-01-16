Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbbAPSfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:35:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbbAPSfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:35:21 -0500
Date: Fri, 16 Jan 2015 10:35:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver fixes for 3.19-rc5
Message-ID: <20150116183520.GA28424@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.19-rc5

for you to fetch changes up to 7b7c54914f73966976893747ee8e2ca58166a627:

  mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0 (2015-01-09 15:46:37 -0800)

----------------------------------------------------------------
Char/Misc driver fixes for 3.19-rc5

Here are 3 small driver fixes for reported issues for 3.19-rc5.  All of
these have been in linux-next for a while with no reported problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (1):
      mei: clean reset bit before reset

Johannes Thumshirn (1):
      mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0

Tomas Winkler (1):
      mei: add ABI documentation for fw_status exported through sysfs

 Documentation/ABI/testing/sysfs-class-mei | 15 +++++++++++++++
 drivers/mcb/mcb-internal.h                |  1 +
 drivers/mcb/mcb-pci.c                     | 27 ++++++++++++++++++---------
 drivers/misc/mei/hw-me.c                  | 12 ++++++++++++
 4 files changed, 46 insertions(+), 9 deletions(-)
