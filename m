Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaKHS7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:59:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaKHS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:59:28 -0500
Date: Sat, 8 Nov 2014 10:58:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.18-rc3
Message-ID: <20141108185812.GA2200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.18-rc4

for you to fetch changes up to c4dc304677e8d566572c4738d95c48be150c6606:

  tty: Fix pty master poll() after slave closes v2 (2014-11-06 12:23:36 -0800)

----------------------------------------------------------------
TTY/Serial fixes for 3.18-rc4

Here are some tiny serial/tty fixes for 3.18-rc4 that resolve some
reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Francesco Ruggeri (1):
      tty: Fix pty master poll() after slave closes v2

Imre Deak (1):
      tty/vt: don't set font mappings on vc not supporting this

Jingchang Lu (1):
      serial: of-serial: fix uninitialized kmalloc variable

Matthias Brugger (1):
      tty: serial: 8250_mtk: Fix quot calculation

Peter Hurley (3):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable
      tty: Prevent "read/write wait queue active!" log flooding

 drivers/tty/n_tty.c                |  9 +++++++--
 drivers/tty/serial/8250/8250_mtk.c |  2 +-
 drivers/tty/serial/of_serial.c     |  2 +-
 drivers/tty/serial/serial_core.c   |  2 +-
 drivers/tty/tty_io.c               | 15 ++++++++++++---
 drivers/tty/vt/consolemap.c        |  7 +++++++
 6 files changed, 29 insertions(+), 8 deletions(-)
