Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016AbaKNEWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:22:01 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58654 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbaKNEWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:22:00 -0500
Date: Thu, 13 Nov 2014 20:21:58 -0800
From: Darren Hart <dvhart@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] platform-drivers-x86 for 3.18-3
Message-ID: <20141114042158.GB3088@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Just two patches to remove hp_accel events from the keyboard bus stream via an
i8042 filter.

My inclination was to merge these, but as I had (incorrectly) pushed them to
linux-next already, and you had cautioned against rebasing and to just fix
issues in follow-on patches, I kept the kconfig i8042 dependency fix as a
separate patch.

If you would prefer I collapse them, I'm happy to resend and rebase my
linux-next branch for the 3.19 cycle. Apologies for the noise.

Thanks,

Darren Hart
Intel Open Source Technology Center

The following changes since commit ed78bb846e8bc1a8589fa6e0d9bf2b0f518893d5:

  Merge tag 'pci-v3.18-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2014-11-06 11:33:06 -0800)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git tags/platform-drivers-x86-v3.18-3

for you to fetch changes up to 0cdbcd6d3ebeffa7d1a475ed7a294315cd046a11:

  platform: hp_accel: Add SERIO_I8042 as a dependency since it now includes i8042.h/serio.h (2014-11-10 21:16:15 -0800)

----------------------------------------------------------------
platform-drivers-x86 for 3.18-3

Remove hp_accel events from keyboard bus stream.

----------------------------------------------------------------
Giedrius Statkevicius (2):
      platform: hp_accel: add a i8042 filter to remove HPQ6000 data from kb bus stream
      platform: hp_accel: Add SERIO_I8042 as a dependency since it now includes i8042.h/serio.h

 drivers/platform/x86/Kconfig    |  1 +
 drivers/platform/x86/hp_accel.c | 44 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)
