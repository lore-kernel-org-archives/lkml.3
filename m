Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3J3Sea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:34:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3J3Se3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:34:29 -0400
Date: Wed, 30 Oct 2013 11:34:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.12-rc8/final
Message-ID: <20131030183428.GA4837@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.12-rc8

for you to fetch changes up to 6e757ad2c92caf721fd0efaac7088247e3934c5e:

  tty/serial: at91: fix uart/usart selection for older products (2013-10-17 13:27:24 -0700)

----------------------------------------------------------------
Serial fixes for 3.12-final

Here are 3 tiny fixes that are needed for 3.12-final for some serial
drivers.  One of them is a revert of a broken patch, and two others are
fixes for reported bugs.  All of these have been in linux-next for a
while, I forgot I had not sent them to you yet, my fault.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Revert "serial: i.MX: evaluate linux,stdout-path property"

Nicolas Ferre (1):
      tty/serial: at91: fix uart/usart selection for older products

Roel Kluin (1):
      serial: vt8500: add missing braces

 drivers/tty/serial/atmel_serial.c  | 9 ++-------
 drivers/tty/serial/imx.c           | 3 ---
 drivers/tty/serial/vt8500_serial.c | 5 +++--
 3 files changed, 5 insertions(+), 12 deletions(-)
