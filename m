Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaFBWGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:06:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaFBWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:06:07 -0400
Date: Mon, 2 Jun 2014 15:09:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.15-rc8
Message-ID: <20140602220944.GA22549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc8

for you to fetch changes up to 9326c5ca0982f548cc08c0cffb14dcbd020f3d43:

  staging: r8192e_pci: fix htons error (2014-05-28 14:46:51 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.15-rc8

Here are some staging driver fixes for 3.15.  3 are for the speakup
drivers (one fix a regression caused in 3.15-rc, and the other 2 resolve
a tty issue found by Ben Hutchings)  The comedi and r8192e_pci driver
fixes also resolve reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ben Hutchings (2):
      Staging: speakup: Move pasting into a work item
      Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to match vt

Ian Abbott (1):
      staging: comedi: ni_daq_700: add mux settling delay

Rusty Russell (1):
      speakup: fix incorrect perms on speakup_acntsa.c

Sean MacLennan (1):
      staging: r8192e_pci: fix htons error

 drivers/staging/comedi/drivers/ni_daq_700.c |  2 ++
 drivers/staging/rtl8192e/rtllib_tx.c        |  2 +-
 drivers/staging/speakup/main.c              |  1 +
 drivers/staging/speakup/selection.c         | 52 ++++++++++++++++++++++++-----
 drivers/staging/speakup/speakup.h           |  1 +
 drivers/staging/speakup/speakup_acntsa.c    |  8 ++---
 drivers/tty/tty_buffer.c                    |  2 ++
 7 files changed, 54 insertions(+), 14 deletions(-)
