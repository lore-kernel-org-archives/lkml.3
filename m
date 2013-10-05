Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3JEReT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:34:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3JEReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:34:17 -0400
Date: Sat, 5 Oct 2013 10:34:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/Serial fixes for 3.12-rc4
Message-ID: <20131005173403.GA4811@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.12-rc4

for you to fetch changes up to a9fbf4d591da6cd1d3eaab826c7c15f77fc8f6a3:

  xen/hvc: allow xenboot console to be used again (2013-10-03 16:12:58 -0700)

----------------------------------------------------------------
TTY fixes for 3.12-rc4

Here are 2 tty driver fixes for 3.12-rc4.

One fixes the reported regression in the n_tty code that a number of
people found recently, and the other one fixes an issue with xen
consoles that broke in 3.10.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
David Vrabel (1):
      xen/hvc: allow xenboot console to be used again

Peter Hurley (1):
      tty: Fix pty master read() after slave closes

 drivers/tty/hvc/hvc_xen.c |  1 +
 drivers/tty/n_tty.c       | 46 ++++++++++++++++++++++++++--------------------
 2 files changed, 27 insertions(+), 20 deletions(-)
