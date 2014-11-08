Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaKHTAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 14:00:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaKHTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 14:00:09 -0500
Date: Sat, 8 Nov 2014 10:58:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fixes for 3.18-rc4
Message-ID: <20141108185853.GA2290@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.18-rc4

for you to fetch changes up to cd3d9ea142c9fd47351e79fe30c7ae2c86302cda:

  tiny: rename ENABLE_DEV_COREDUMP to ALLOW_DEV_COREDUMP (2014-11-07 11:07:35 -0800)

----------------------------------------------------------------
Driver core fixes for 3.18-rc4

Here are 3 tiny fixes for 3.18-rc4.  One fixes up a long-stading race
condition in the driver core for removing directories in
/sys/devices/virtual/ and the other 2 fix up the wording of a new
Kconfig option that was added in 3.18-rc1.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aristeu Rozanski (1):
      tiny: reverse logic for DISABLE_DEV_COREDUMP

Johannes Berg (1):
      tiny: rename ENABLE_DEV_COREDUMP to ALLOW_DEV_COREDUMP

Yijing Wang (1):
      sysfs: driver core: Fix glue dir race condition by gdp_mutex

 drivers/base/Kconfig | 19 +++++++++++--------
 drivers/base/core.c  |  4 +++-
 2 files changed, 14 insertions(+), 9 deletions(-)
