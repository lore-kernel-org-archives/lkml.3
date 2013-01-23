Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3AWXze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:55:34 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62725 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3AWXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:55:25 -0500
Date: Wed, 23 Jan 2013 15:55:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] more TTY/Serial fixes for 3.8-rc4
Message-ID: <20130123235520.GA11415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 248152b60209874b1707a23d336b137486756a29:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k (2013-01-23 13:31:15 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.8-rc4

for you to fetch changes up to 5e30bbb723415fb94a098e314d1908a39a7e50a2:

  MAINTAINERS: Someone needs to watch over the serial drivers (2013-01-23 15:45:23 -0800)

----------------------------------------------------------------
TTY patches for 3.8-rc4

Just a MAINTAINERS update, now that Alan has left for a bit, I'll
continue to watch over the serial drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      MAINTAINERS: Someone needs to watch over the serial drivers

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)
