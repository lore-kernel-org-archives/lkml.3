Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031748Ab3HIXxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:53:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031468Ab3HIXxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:53:08 -0400
Date: Fri, 9 Aug 2013 16:53:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.11-rc5
Message-ID: <20130809235307.GA22360@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.11-rc5

for you to fetch changes up to cefe8a32f2a5887246ed250115e34bee6ecc8d61:

  Merge tag 'iio-fixes-for-3.11b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2013-08-05 14:04:24 +0800)

----------------------------------------------------------------

Staging driver fixes for 3.11-rc5

Here are 3 small fixes for staging/IIO drivers for 3.11-rc5.  Nothing
huge, two IIO driver fixes, and a zcache fix.  All of these have been in
linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.11b' of git://git.kernel.org/.../jic23/iio into staging-linus

Lars-Peter Clausen (1):
      iio:trigger: Fix use_count race condition

Patil, Rachna (1):
      iio: ti_am335x_adc: Fix wrong samples received on 1st read

Piotr Sarna (1):
      staging: zcache: fix "zcache=" kernel parameter

 drivers/iio/adc/ti_am335x_adc.c      | 30 ++++++++++++++++++++++--------
 drivers/iio/industrialio-trigger.c   | 34 ++++++++++++++++++++++------------
 drivers/staging/zcache/zcache-main.c |  6 ++++--
 include/linux/iio/trigger.h          |  3 ++-
 include/linux/mfd/ti_am335x_tscadc.h | 16 ++++++++++++++++
 5 files changed, 66 insertions(+), 23 deletions(-)
