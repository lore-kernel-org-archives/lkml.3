Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3JQRhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:37:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab3JQRhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:37:06 -0400
Date: Thu, 17 Oct 2013 10:37:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.12-rc6
Message-ID: <20131017173705.GA8092@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.12-rc6

for you to fetch changes up to d969de8d83401683420638c8107dcfedb2146f37:

  serial: vt8500: add missing braces (2013-10-16 13:22:16 -0700)

----------------------------------------------------------------
Serial driver fixes for 3.12-rc6

Here are two serial driver fixes for your tree.  One is a revert of a
patch that causes a build error, the other is a fix to provide the
correct brace placement which resolves a bug where the driver was not
working properly.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Revert "serial: i.MX: evaluate linux,stdout-path property"

Roel Kluin (1):
      serial: vt8500: add missing braces

 drivers/tty/serial/imx.c           | 3 ---
 drivers/tty/serial/vt8500_serial.c | 5 +++--
 2 files changed, 3 insertions(+), 5 deletions(-)
