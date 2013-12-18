Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3LRRmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:42:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3LRRmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:42:32 -0500
Date: Wed, 18 Dec 2013 09:42:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PULL] TTY/Serial fixes for 3.13-rc5
Message-ID: <20131218174233.GA32642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.13-rc5

for you to fetch changes up to c2db11eca089b60148ded7467b956a547e8a2ae0:

  tty: xuartps: Properly guard sysrq specific code (2013-12-17 16:02:25 -0800)

----------------------------------------------------------------
TTY/Serial fixes for 3.13-rc5

Here are a few fixes for 3.13-rc5 that resolve a number of reported tty
and serial driver issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
James Hogan (1):
      serial: 8250_dw: Fix LCR workaround regression

Mika Westerberg (1):
      serial: 8250_dw: add new ACPI IDs

Peter Hurley (2):
      tty: Fix hang at ldsem_down_read()
      n_tty: Fix apparent order of echoed output

Soren Brinkmann (1):
      tty: xuartps: Properly guard sysrq specific code

 drivers/tty/n_tty.c                |  7 ++++++-
 drivers/tty/serial/8250/8250_dw.c  |  8 ++++++--
 drivers/tty/serial/xilinx_uartps.c |  2 ++
 drivers/tty/tty_ldsem.c            | 16 +++++++++++++---
 4 files changed, 27 insertions(+), 6 deletions(-)
