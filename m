Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaGLUmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:42:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaGLUmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:42:43 -0400
Date: Sat, 12 Jul 2014 13:47:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc driver fixes for 3.16-rc5
Message-ID: <20140712204712.GA25253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.16-rc5

for you to fetch changes up to 6d827fbcc370ca259a2905309f64161ab7b10596:

  i8k: Fix non-SMP operation (2014-07-09 16:45:36 -0700)

----------------------------------------------------------------
char/misc driver fixes for 3.16-rc5

Here are 2 hyperv driver fixes, and one i8k driver fix for 3.16.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Guenter Roeck (1):
      i8k: Fix non-SMP operation

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
      Drivers: hv: util: Fix a bug in the KVP code

 drivers/char/i8k.c      |  4 +++-
 drivers/hv/connection.c |  8 ++++++--
 drivers/hv/hv_kvp.c     | 17 ++++++++++++++---
 drivers/hv/hv_util.c    |  2 +-
 4 files changed, 24 insertions(+), 7 deletions(-)
