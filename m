Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab3COQ5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:57:42 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41412 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3COQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:57:41 -0400
Date: Fri, 15 Mar 2013 09:57:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [GIT PATCH] char/misc fixes for 3.9-rc2
Message-ID: <20130315165738.GA20639@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.9-rc2

for you to fetch changes up to 3d374d09f16f64ab4d71704cbe621514d36cd0b1:

  final removal of CONFIG_EXPERIMENTAL (2013-03-12 16:30:27 -0700)

----------------------------------------------------------------
Char/misc fixes for 3.9-rc2

Here are some tiny fixes for the w1 drivers and the final removal patch
for getting rid of CONFIG_EXPERIMENTAL (all users of it are now gone
from your tree, this just drops the Kconfig item itself.)

All have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Johan Hovold (3):
      ARM: w1-gpio: fix erroneous gpio requests
      w1-gpio: remove erroneous __exit and __exit_p()
      w1-gpio: fix unused variable warning

Kees Cook (1):
      final removal of CONFIG_EXPERIMENTAL

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

 arch/arm/mach-at91/board-foxg20.c    | 1 +
 arch/arm/mach-at91/board-stamp9g20.c | 1 +
 arch/arm/mach-ixp4xx/vulcan-setup.c  | 1 +
 arch/arm/mach-pxa/raumfeld.c         | 1 +
 drivers/w1/masters/w1-gpio.c         | 6 ++++--
 drivers/w1/w1.c                      | 3 ++-
 init/Kconfig                         | 4 ----
 7 files changed, 10 insertions(+), 7 deletions(-)
