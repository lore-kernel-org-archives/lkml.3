Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbaFTUAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:00:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbaFTUAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:00:05 -0400
Date: Fri, 20 Jun 2014 13:04:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver fixes for 3.16-rc2
Message-ID: <20140620200406.GA28891@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.16-rc2

for you to fetch changes up to 73b35d07ee20d6af95359fb86540528709dd58bb:

  MAINTAINERS: add entry for VMware Balloon driver (2014-06-20 11:47:33 -0700)

----------------------------------------------------------------
Char / Misc driver fixes for 3.16-rc2

Here are 3 patches, one a revert of the UIO patch you objected to in
3.16-rc1 and that no one wanted to defend, a w1 driver bugfix, and a
MAINTAINERS update for the vmware balloon driver.  All of these, except
for the MAINTAINERS update which just got added, have been in linux-next just
fine.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (1):
      w1: mxc_w1: Fix incorrect "presence" status

Dmitry Torokhov (1):
      MAINTAINERS: add entry for VMware Balloon driver

Greg Kroah-Hartman (1):
      Revert "uio: fix vma io range check in mmap"

 MAINTAINERS                 | 8 ++++++++
 drivers/misc/vmw_balloon.c  | 3 ++-
 drivers/uio/uio.c           | 2 +-
 drivers/w1/masters/mxc_w1.c | 2 +-
 4 files changed, 12 insertions(+), 3 deletions(-)
