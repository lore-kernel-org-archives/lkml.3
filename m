Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3G3TRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:17:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3G3TRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:17:19 -0400
Date: Tue, 30 Jul 2013 12:17:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.11-rc4
Message-ID: <20130730191717.GA26474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3bf5d350586d98eb28ab7f86ffbd66518ffd95d8:

  serial: tegra: correct help message in Kconfig from 'ttyHS' to 'ttyTHS' (2013-07-24 15:23:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.11-rc4

for you to fetch changes up to d5a12ea7a9e58d9e5c19d25cb668aadb396423ec:

  serial: arc_uart: Fix module alias (2013-07-26 16:34:00 -0700)

----------------------------------------------------------------
TTY/Serial driver fixes for 3.11-rc4

Here are 4 tiny tty and serial driver fixes for 3.11-rc4.

Nothing big, a refcount leak, a module alias fix, and two fixes to the
mxs-auart serial driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      serial: arc_uart: Fix module alias

Gianluca Anzolin (1):
      tty_port: Fix refcounting leak in tty_port_tty_hangup()

Uwe Kleine-König (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

 drivers/tty/serial/arc_uart.c  |  2 +-
 drivers/tty/serial/mxs-auart.c | 38 ++++++++++++++++++++++----------------
 drivers/tty/tty_port.c         |  5 ++---
 3 files changed, 25 insertions(+), 20 deletions(-)
