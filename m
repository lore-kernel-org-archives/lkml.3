Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3HYSW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:22:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HYSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:22:56 -0400
Date: Sun, 25 Aug 2013 11:25:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.11-rc7
Message-ID: <20130825182507.GA18074@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.11-rc7

for you to fetch changes up to 3955dfa8216f712bc204a5ad2f4e51efff252fde:

  staging: comedi: bug-fix NULL pointer dereference on failed attach (2013-08-23 10:31:47 -0700)

----------------------------------------------------------------
Staging fixes for 3.11-rc7

Here are two tiny staging tree fixes (well, one is for an iio driver,
but those updates come through the staging tree due to dependancies.)

One fixes a problem with an IIO driver, and the other fixes a bug in the
comedi driver core.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.11c' of git://git.kernel.org/.../jic23/iio into staging-linus

Ian Abbott (1):
      staging: comedi: bug-fix NULL pointer dereference on failed attach

Peter Meerwald (1):
      iio: adjd_s311: Fix non-scan mode data read

 drivers/iio/light/adjd_s311.c    | 3 ++-
 drivers/staging/comedi/drivers.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
