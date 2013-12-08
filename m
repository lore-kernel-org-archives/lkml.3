Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab3LHUrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 15:47:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:15789 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab3LHUrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 15:47:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,852,1378882800"; 
   d="scan'208";a="440648880"
Date: Sun, 8 Dec 2013 21:47:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [3.13] MFD fixes
Message-ID: <20131208204719.GP6489@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first 3.13 pull request for MFD fixes. We have:

- A ti-ssp build failure fix.
- An as3722 build failure fix.
- An lpc_ich copy paste error fix.

Thanks for pulling those one in.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git tags/mfd-fixes-3.13-1

for you to fetch changes up to 88ec6a4d836904a75bef87bfcd906193ad11d88a:

  Merge tag 'mfd-lee-3.13-fixes-1' of git://git.linaro.org/people/ljones/mfd (2013-11-27 09:40:20 +0100)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      mfd: ti-ssp: Fix build

James Ralston (1):
      mfd: lpc_ich: Fix Wildcat Point info name field

Michal Marek (1):
      mfd: Make MFD_AS3722 depend on I2C=y

Samuel Ortiz (1):
      Merge tag 'mfd-lee-3.13-fixes-1' of git://git.linaro.org/people/ljones/mfd

 drivers/mfd/Kconfig   | 2 +-
 drivers/mfd/lpc_ich.c | 2 +-
 drivers/mfd/ti-ssp.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
