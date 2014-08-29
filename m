Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaH2Rle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:41:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaH2Rld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:41:33 -0400
Date: Fri, 29 Aug 2014 10:41:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver fixes for 3.17-rc3
Message-ID: <20140829174133.GA7012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.17-rc3

for you to fetch changes up to 72ad366f687d45f30a82d8b6e70ce757b21b5aab:

  thunderbolt: Clear hops before overwriting (2014-08-26 14:54:48 -0700)

----------------------------------------------------------------
Char/Misc driver fixes for 3.17-rc3

Here are 3 fixes for the mei and thunderbolt drivers that resolve some
reported issues.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Usyskin (2):
      mei: reset client state on queued connect request
      mei: nfc: fix memory leak in error path

Andreas Noever (1):
      thunderbolt: Clear hops before overwriting

 drivers/misc/mei/client.c  |  1 +
 drivers/misc/mei/nfc.c     | 11 +++++------
 drivers/thunderbolt/path.c | 21 ++++++++++++++++++++-
 3 files changed, 26 insertions(+), 7 deletions(-)
