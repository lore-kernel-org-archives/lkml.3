Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab3DJWsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:48:45 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45352 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937394Ab3DJWsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:48:43 -0400
Date: Wed, 10 Apr 2013 15:48:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.9-rc6
Message-ID: <20130410224840.GA32608@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.9-rc6

for you to fetch changes up to 1b581f173992cded311f810346378f763a1f1e5d:

  tty: mxser: fix cycle termination condition in mxser_probe() and mxser_module_init() (2013-04-08 11:30:04 -0700)

----------------------------------------------------------------
TTY/Serial fixes for 3.9-rc6

Here are 4 small tty/serial fixes for 3.9.

One fixes a bug where we broke the documentation build, and the others
fix reported problems in some serial drivers.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexey Khoroshilov (1):
      tty: mxser: fix cycle termination condition in mxser_probe() and mxser_module_init()

Alexey Pelykh (1):
      OMAP/serial: Revert bad fix of Rx FIFO threshold granularity

Guennadi Liakhovetski (1):
      tty: Documentation: fix a path in a DocBook template

Sean Young (1):
      Revert "tty/8250_pnp: serial port detection regression since v3.7"

 Documentation/DocBook/device-drivers.tmpl |  2 +-
 drivers/tty/mxser.c                       |  8 ++++----
 drivers/tty/serial/8250/8250_pnp.c        | 12 +++++-------
 drivers/tty/serial/omap-serial.c          | 11 +++++++++++
 4 files changed, 21 insertions(+), 12 deletions(-)
