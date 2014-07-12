Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaGLUnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaGLUnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:43:03 -0400
Date: Sat, 12 Jul 2014 13:47:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.16-rc5
Message-ID: <20140712204732.GA27346@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.16-rc5

for you to fetch changes up to 34c4eda809e1efb16c554c07bb5df4c8ace9424e:

  serial: sh-sci: Add device tree support for r8a7{778,740,3a4} and sh73a0 (2014-07-11 17:45:12 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.16-rc5

Here are some small serial fixes that resolve some reported problems
that started in 3.15 with some serial drivers.  And there's a new dt
binding for a serial driver, which was all that was needed for the
renesas serial driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Peter Hurley (3):
      serial: Test for no tx data on tx restart
      serial: arc_uart: Use uart_circ_empty() for open-coded comparison
      serial: imx: Fix build breakage

Simon Horman (1):
      serial: sh-sci: Add device tree support for r8a7{778,740,3a4} and sh73a0

 Documentation/devicetree/bindings/serial/renesas,sci-serial.txt | 7 +++++++
 drivers/tty/serial/arc_uart.c                                   | 2 +-
 drivers/tty/serial/imx.c                                        | 3 +++
 drivers/tty/serial/ip22zilog.c                                  | 2 ++
 drivers/tty/serial/m32r_sio.c                                   | 8 +++++---
 drivers/tty/serial/pmac_zilog.c                                 | 3 +++
 drivers/tty/serial/sunsab.c                                     | 3 +++
 drivers/tty/serial/sunzilog.c                                   | 2 ++
 8 files changed, 26 insertions(+), 4 deletions(-)
