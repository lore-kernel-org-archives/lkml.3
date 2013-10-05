Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3JEReS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:34:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3JEReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:34:17 -0400
Date: Sat, 5 Oct 2013 10:33:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.12-rc4
Message-ID: <20131005173340.GA4791@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.12-rc4

for you to fetch changes up to 677a31565692d596ef42ea589b53ba289abf4713:

  staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice (2013-10-03 14:27:32 -0700)

----------------------------------------------------------------
Staging fixes for 3.12-rc4

Here are 4 tiny staging and iio driver fixes for 3.12-rc4.  Nothing
major, just some small fixes for reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Denis CIOCCA (1):
      iio:magnetometer: Bugfix magnetometer default output registers

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.12b2' of git://git.kernel.org/.../jic23/iio into staging-linus

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Lars-Peter Clausen (1):
      iio: Remove debugfs entries in iio_device_unregister()

Sachin Kamat (1):
      iio: amplifiers: ad8366: Remove regulator_put

 drivers/iio/amplifiers/ad8366.c          |  4 +---
 drivers/iio/industrialio-core.c          |  2 +-
 drivers/iio/magnetometer/st_magn_core.c  | 18 +++++++++---------
 drivers/staging/comedi/drivers/ni_65xx.c | 25 ++++++++++---------------
 4 files changed, 21 insertions(+), 28 deletions(-)
