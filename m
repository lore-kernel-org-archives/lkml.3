Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3FFR6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:58:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3FFR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:58:06 -0400
Date: Thu, 6 Jun 2013 10:58:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.10-rc5
Message-ID: <20130606175805.GA25986@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.10-rc4

for you to fetch changes up to 317a68427d4b0a302ecff252fd83a00557947db8:

  Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work correctly" (2013-06-03 10:08:28 -0700)

----------------------------------------------------------------
TTY/Serial driver fixes for 3.10-rc4

Here are some small bugfixes, and one revert, of serial driver issues
that have been reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Chander Kashyap (1):
      serial: samsung: enable clock before clearing pending interrupts during init

Kyle McMartin (1):
      Revert "serial: 8250: Make SERIAL_8250_RUNTIME_UARTS work correctly"

Lucas Stach (1):
      serial/imx: disable hardware flow control at startup

 drivers/tty/serial/8250/8250_core.c | 14 +++++++-------
 drivers/tty/serial/imx.c            |  2 ++
 drivers/tty/serial/samsung.c        | 13 +++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)
