Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3ANFCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:02:30 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64673 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3ANFC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:02:29 -0500
Date: Sun, 13 Jan 2013 21:03:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc changes for 3.8-rc3
Message-ID: <20130114050314.GA8526@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.8-rc3

for you to fetch changes up to e6028db0146cf5a68dbd1508225ea49840997880:

  mei: fix mismatch in mutex unlock-lock in mei_amthif_read() (2013-01-07 10:28:03 -0800)

----------------------------------------------------------------
Char/misc fix for 3.8-rc3

Here is a single fix for the mei driver that resolves a reported issue.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexey Khoroshilov (1):
      mei: fix mismatch in mutex unlock-lock in mei_amthif_read()

 drivers/misc/mei/amthif.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
