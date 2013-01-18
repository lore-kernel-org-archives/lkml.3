Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3ARTwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:52:42 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33181 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3ARTwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:52:40 -0500
Date: Fri, 18 Jan 2013 11:52:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.8-rc4
Message-ID: <20130118195236.GA18913@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e6028db0146cf5a68dbd1508225ea49840997880:

  mei: fix mismatch in mutex unlock-lock in mei_amthif_read() (2013-01-07 10:28:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.8-rc4

for you to fetch changes up to 33080c1cda280b918349c676cb75bedb6db4a772:

  Drivers: hv: balloon: Fix a memory leak (2013-01-17 11:58:00 -0800)

----------------------------------------------------------------
Char/Misc driver fixes for 3.8-rc4

Here are two hyperv patches for 3.8-rc4 that fix some reported problems
hv_balloon driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
K. Y. Srinivasan (2):
      Drivers: hv: balloon: Fix a bug in the definition of struct dm_info_msg
      Drivers: hv: balloon: Fix a memory leak

 drivers/hv/hv_balloon.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)
