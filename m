Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaHAV1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 17:27:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaHAV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 17:27:35 -0400
Date: Fri, 1 Aug 2014 14:27:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.16-rc8
Message-ID: <20140801212733.GA5861@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.16-rc8

for you to fetch changes up to 4aa0abed3a2a11b7d71ad560c1a3e7631c5a31cd:

  staging: vt6655: Fix disassociated messages every 10 seconds (2014-07-24 15:10:42 -0700)

----------------------------------------------------------------
Staging driver bugfixes for 3.16-rc8

Here are some tiny staging driver bugfixes that I've had in my tree for
the past week that resolve some reported issues.  Nothing major at all,
but it would be good to get them merged for 3.16-rc8 or -final.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.16e' of git://git.kernel.org/.../jic23/iio into staging-linus

Jes Sorensen (1):
      staging: rtl8723au: rtw_resume(): release semaphore before exit on error

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Malcolm Priestley (2):
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
      staging: vt6655: Fix disassociated messages every 10 seconds

Peter Meerwald (2):
      iio:bma180: Fix scale factors to report correct acceleration units
      iio:bma180: Missing check for frequency fractional part

 drivers/iio/accel/bma180.c                  | 8 +++++---
 drivers/iio/industrialio-buffer.c           | 2 +-
 drivers/staging/rtl8723au/os_dep/usb_intf.c | 4 +++-
 drivers/staging/vt6655/bssdb.c              | 2 +-
 drivers/staging/vt6655/device_main.c        | 7 +++++--
 5 files changed, 15 insertions(+), 8 deletions(-)
