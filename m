Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaILSVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:21:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaILSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:21:00 -0400
Date: Fri, 12 Sep 2014 11:21:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial patches for 3.17-rc5
Message-ID: <20140912182100.GA2015@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.17-rc5

for you to fetch changes up to 6731af573ac28de2297002992f38caa760e3dadf:

  tty: xuartps: Fix tx_emtpy() callback (2014-09-08 16:33:56 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.17-rc5

Here are 3 patches for 3.17-rc5.  Two serial driver fixes that resolve
some reported issues, and one new device id.

All have been in linux-next just fine.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      serial: 8250_dw: Add ACPI ID for Intel Braswell

Lars-Peter Clausen (1):
      tty: xuartps: Fix tx_emtpy() callback

Richard Genoud (1):
      tty/serial: at91: BUG: disable interrupts when !UART_ENABLE_MS()

 drivers/tty/serial/8250/8250_dw.c  |  1 +
 drivers/tty/serial/atmel_serial.c  | 43 +++++++++++++++++++++++++++++++++++++-
 drivers/tty/serial/xilinx_uartps.c |  2 +-
 3 files changed, 44 insertions(+), 2 deletions(-)
