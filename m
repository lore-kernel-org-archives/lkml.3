Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaH2RmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaH2RmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:42:02 -0400
Date: Fri, 29 Aug 2014 10:42:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.17-rc3
Message-ID: <20140829174201.GA7138@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.17-rc3

for you to fetch changes up to a2fa6721c7237b5a666f16f732628c0c09c0b954:

  staging: r8188eu: Add new USB ID (2014-08-25 15:00:56 -0700)

----------------------------------------------------------------
staging driver fixes for 3.17-rc3

Here are some staging driver fixes for your tree.  Nothing huge, just
some fixes for issues that have been reported and a few new device ids
added.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Holger Paradies (1):
      staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

Larry Finger (1):
      staging: r8188eu: Add new USB ID

Mark Einon (1):
      staging: et131x: Fix errors caused by phydev->addr accesses before initialisation

Pranith Kumar (1):
      staging: lustre: Remove circular dependency on header

Rickard Strandqvist (1):
      staging: lustre: lustre: libcfs: workitem.c: Cleaning up missing null-terminate after strncpy call

Seunghun Lee (1):
      staging: android: fix a possible memory leak

 drivers/staging/android/logger.c                   |  5 +-
 drivers/staging/et131x/et131x.c                    | 68 +++++++++-------------
 drivers/staging/lustre/lustre/libcfs/workitem.c    |  1 +
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  2 +
 5 files changed, 35 insertions(+), 43 deletions(-)
