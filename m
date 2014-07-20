Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaGTTzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:55:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaGTTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:55:48 -0400
Date: Sun, 20 Jul 2014 12:55:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver fixes for 3.16-rc6
Message-ID: <20140720195546.GA4822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.16-rc6

for you to fetch changes up to 2ef82d24f445e82f80e235f44eb9d1bc933e3670:

  Drivers: hv: hv_fcopy: fix a race condition for SMP guest (2014-07-17 18:43:10 -0700)

----------------------------------------------------------------
char/misc fix for 3.16-rc6

Here's a single hyper-v driver fix for a reported issue.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dexuan Cui (1):
      Drivers: hv: hv_fcopy: fix a race condition for SMP guest

 drivers/hv/hv_fcopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
