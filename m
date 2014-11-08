Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaKHS7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:59:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaKHS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:59:45 -0500
Date: Sat, 8 Nov 2014 10:58:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.18-rc4
Message-ID: <20141108185829.GA2246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.18-rc4

for you to fetch changes up to bce20b2396626301c65e08306364bce9a7505ae5:

  Merge tag 'iio-fixes-for-3.18b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2014-11-05 11:30:45 -0800)

----------------------------------------------------------------
Staging driver fixes for 3.18-rc4

Here are some staging/iio fixes for 3.18-rc4.

Nothing major, just a few bugfixes of things that have been reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dan Murphy (1):
      iio: tsl4531: Fix compiler error when CONFIG_PM_OPS is not defined

Daniel Baluta (1):
      io: accel: kxcjk-1013: Fix iio_event_spec direction

Fabio Estevam (1):
      iio: adc: mxs-lradc: Disable the clock on probe failure

George McCollister (1):
      iio: as3935: allocate correct iio_device size

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.18b' of git://git.kernel.org/.../jic23/iio into staging-linus

Lars-Peter Clausen (5):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

 drivers/iio/accel/kxcjk-1013.c           |  2 +-
 drivers/iio/light/tsl4531.c              |  7 ++--
 drivers/iio/proximity/as3935.c           |  2 +-
 drivers/staging/iio/meter/ade7758.h      |  1 -
 drivers/staging/iio/meter/ade7758_core.c | 57 ++++++--------------------------
 drivers/staging/iio/meter/ade7758_ring.c |  5 ++-
 6 files changed, 20 insertions(+), 54 deletions(-)
