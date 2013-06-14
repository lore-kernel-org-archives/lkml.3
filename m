Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3FNQjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:39:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3FNQjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:39:47 -0400
Date: Fri, 14 Jun 2013 09:40:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.10-rc6
Message-ID: <20130614164024.GA26053@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.10-rc5

for you to fetch changes up to 42f132febff3b7b42c6c9dbfc151f29233be3132:

  mei: me: clear interrupts on the resume path (2013-06-13 22:31:07 -0700)

----------------------------------------------------------------
Char / Misc fixes for 3.10-rc6

Here are some small mei driver fixes for 3.10-rc6 that fix some reported
problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Samuel Ortiz (1):
      mei: init: Flush scheduled work before resetting the device

Tomas Winkler (2):
      mei: nfc: fix nfc device freeing
      mei: me: clear interrupts on the resume path

 drivers/misc/mei/init.c   | 4 ++--
 drivers/misc/mei/nfc.c    | 2 ++
 drivers/misc/mei/pci-me.c | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)
