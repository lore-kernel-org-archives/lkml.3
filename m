Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3GZQ5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:57:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab3GZQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:57:46 -0400
Date: Fri, 26 Jul 2013 09:57:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.11-rc3
Message-ID: <20130726165745.GA22891@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.11-rc3

for you to fetch changes up to 3bf5d350586d98eb28ab7f86ffbd66518ffd95d8:

  serial: tegra: correct help message in Kconfig from 'ttyHS' to 'ttyTHS' (2013-07-24 15:23:38 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.11-rc3

Here are 3 fixes for TTY and serial issues that have been reported.
Nothing huge, but nice to get fixed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dan Carpenter (1):
      TTY: snyclinkmp: calculating wrong addresses

Henrik Nordström (1):
      tty/8250_early: Don't truncate last character of options

Richard Zhao (1):
      serial: tegra: correct help message in Kconfig from 'ttyHS' to 'ttyTHS'

 drivers/tty/serial/8250/8250_early.c | 3 ++-
 drivers/tty/serial/Kconfig           | 2 +-
 drivers/tty/synclinkmp.c             | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)
