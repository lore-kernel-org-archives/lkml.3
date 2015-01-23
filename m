Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbbAWXCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:02:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbAWXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:02:46 -0500
Date: Fri, 23 Jan 2015 15:02:44 -0800
From: Darren Hart <dvhart@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] platform-drivers-x86 for 3.19-2
Message-ID: <20150123230244.GA76977@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The support for the dell-laptop keyboard backlight was flawed and the fix:

https://lkml.org/lkml/2015/1/14/539

was more invasive that I felt comfortable sending at RC5.

This series reverts the support for the dell-laptop keyboard backlight as well
as the documentation for the newly created sysfs attributes. We'll get this
implemented correctly for 3.20.

Thanks,

Darren Hart
Intel Open Source Technology Center

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git tags/platform-drivers-x86-v3.19-2

for you to fetch changes up to b78695a71de994cdbd58f4b3be9085a60bd2203d:

  Revert "platform: x86: dell-laptop: Add support for keyboard backlight" (2015-01-23 11:10:32 -0800)

----------------------------------------------------------------
platform-drivers-x86 for 3.19-2

dell-laptop: Revert keyboard backlight sysfs support and documentation

----------------------------------------------------------------
Darren Hart (2):
      Revert "Documentation: Add entry for dell-laptop sysfs interface"
      Revert "platform: x86: dell-laptop: Add support for keyboard backlight"

 .../ABI/testing/sysfs-platform-dell-laptop         |   60 --
 drivers/platform/x86/dell-laptop.c                 | 1055 +-------------------
 2 files changed, 6 insertions(+), 1109 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-platform-dell-laptop
-- 
Darren Hart
Intel Open Source Technology Center
