Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaBVXI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:08:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaBVXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:08:25 -0500
Date: Sat, 22 Feb 2014 15:11:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc fix for 3.14-rc4
Message-ID: <20140222231109.GA28506@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.14-rc4

for you to fetch changes up to accb884b32e82f943340688c9cd30290531e73e0:

  mei: set client's read_cb to NULL when flow control fails (2014-02-18 10:07:36 -0800)

----------------------------------------------------------------
Char/Misc fix for 3.14-rc4

Here is a single commit, to fix a reported problem in the mei driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Chao Bi (1):
      mei: set client's read_cb to NULL when flow control fails

 drivers/misc/mei/client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
