Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3ARTxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:53:07 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43668 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab3ARTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:53:05 -0500
Date: Fri, 18 Jan 2013 11:53:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.8-rc3
Message-ID: <20130118195301.GA18980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 397c60668aa5ae7130b5ad4e73870d7b8a787085:

  staging: zram: fix invalid memory references during disk write (2013-01-13 19:40:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.8-rc4

for you to fetch changes up to 7dfc8331781f954bbea5c59d4411acf3b28530c1:

  staging/sb105x: PARPORT config is not good enough must use PARPORT_PC (2013-01-17 16:39:41 -0800)

----------------------------------------------------------------
Staging bugfixes for 3.8-rc4

Here are some bugfixes for the drivers/staging tree for 3.8-rc4.

Nothing major, just a number of small fixes for problems that people
have reported, including finally tracking down the root of the 64/32 bit
problem with the vt6656 that has been driving people crazy for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ben Hutchings (1):
      staging: vt6656: Fix inconsistent structure packing

Fabio Estevam (1):
      iio: mxs-lradc: indexes are unsigned

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.8b' of git://git.kernel.org/.../jic23/iio into staging-linus

Lars-Peter Clausen (1):
      staging:iio:adis16080: Perform sign extension

Steven Rostedt (1):
      staging/sb105x: PARPORT config is not good enough must use PARPORT_PC

Tormod Volden (1):
      staging: wlan-ng: Fix clamping of returned SSID length

 drivers/staging/iio/adc/mxs-lradc.c       |  2 +-
 drivers/staging/iio/gyro/adis16080_core.c |  2 +-
 drivers/staging/sb105x/sb_pci_mp.c        |  2 +-
 drivers/staging/vt6656/bssdb.h            |  1 -
 drivers/staging/vt6656/int.h              |  1 -
 drivers/staging/vt6656/iocmd.h            | 33 ++++++++++++++++-----------------
 drivers/staging/vt6656/iowpa.h            |  8 +++-----
 drivers/staging/wlan-ng/prism2mgmt.c      |  2 +-
 8 files changed, 23 insertions(+), 28 deletions(-)
