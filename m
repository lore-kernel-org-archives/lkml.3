Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbbAPSeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:34:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbbAPSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:34:18 -0500
Date: Fri, 16 Jan 2015 10:34:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.19-rc5
Message-ID: <20150116183417.GA28290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.19-rc5

for you to fetch changes up to a307d1d6d4cf66723a395785fd4c5998fe922b61:

  staging: vt6655: fix sparse warning: argument type (2015-01-12 19:49:47 -0800)

----------------------------------------------------------------
staging/iio driver fixes for 3.19-rc5

Here are 6 staging driver fixes for 3.19-rc5.

They fix some reported issues with some IIO drivers, as well as some
issues with the vt6655 wireless driver.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Eddie Kovsky (1):
      staging: vt6655: fix sparse warning: argument type

Fabien Proriol (1):
      iio: iio: Fix iio_channel_read return if channel havn't info

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.19a' of git://git.kernel.org/.../jic23/iio into staging-linus

Lars-Peter Clausen (1):
      iio: ad799x: Fix ad7991/ad7995/ad7999 config setup

Malcolm Priestley (2):
      staging: vt6655: vnt_tx_packet Fix corrupted tx packets.
      staging: vt6655: Fix loss of distant/weak access points on channel change.

Mike Krinkin (1):
      staging: vt6655: fix sparse warnings: incorrect argument type

 drivers/iio/adc/ad799x.c             | 15 +++++++++++++--
 drivers/iio/inkern.c                 |  3 +++
 drivers/staging/vt6655/baseband.c    |  2 +-
 drivers/staging/vt6655/channel.c     |  8 ++++++++
 drivers/staging/vt6655/device_main.c | 13 ++++++++++---
 drivers/staging/vt6655/rxtx.c        |  5 +----
 6 files changed, 36 insertions(+), 10 deletions(-)
