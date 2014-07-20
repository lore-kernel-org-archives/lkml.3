Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaGTT6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:58:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaGTT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:58:14 -0400
Date: Sun, 20 Jul 2014 12:58:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.16-rc6
Message-ID: <20140720195813.GA27936@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.16-rc6

for you to fetch changes up to 9359003385a2faffa502d201771d45624037a4cd:

  Merge tag 'iio-fixes-for-3.16d' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2014-07-13 15:47:26 -0700)

----------------------------------------------------------------
Staging fixes for 3.16-rc6

Here are 2 IIO driver fixes for 3.16-rc6 that resolve some reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.16d' of git://git.kernel.org/.../jic23/iio into staging-linus

Martin Fuzzey (1):
      iio: mma8452: Use correct acceleration units.

Srinivas Pandruvada (1):
      iio:core: Handle error when mask type is not separate

 drivers/iio/accel/mma8452.c      | 8 +++++++-
 drivers/iio/industrialio-event.c | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)
