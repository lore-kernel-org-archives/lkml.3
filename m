Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaIDCz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:55:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaIDCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:55:57 -0400
Date: Wed, 3 Sep 2014 19:55:51 -0700
From: Darren Hart <dvhart@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [GIT PULL] platform-drivers-x86 MAINTAINERS and fixes for v3.17
Message-ID: <20140904025551.GA24229@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is my first pull request since taking on maintenance for the
platform-drivers-x86 tree from Matthew Garrett. These have passed my build
testing and been run through Fengguang's LKP tests. Due to timing this round,
these have not spent any time in linux-next. I have asked Stephen to include my
for-next branch in linux-next going forward, once he's back from vacation.

Thanks,

Darren Hart
Intel Open Source Technology Center

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git tags/platform-drivers-x86-v3.17-1

for you to fetch changes up to aeaac098bd58349d7415acd998089309fd798190:

  toshiba_acpi: fix and cleanup toshiba_kbd_bl_mode_store() (2014-09-03 10:45:12 -0700)

----------------------------------------------------------------
platform-drivers-x86 MAINTAINERS and fixes for v3.17

toshiba_acpi: Re-enable hotkeys and cleanups
ideapad-laptop: Revert touchpad disable, and cleanup static/const usage
MAINTAINERS: Update platform-drivers-x86 maintainer and tree

----------------------------------------------------------------
Benjamin Tissoires (1):
      platform/x86: toshiba: re-enable acpi hotkeys after suspend to disk

Dan Carpenter (1):
      toshiba_acpi: fix and cleanup toshiba_kbd_bl_mode_store()

Darren Hart (1):
      MAINTAINERS: Update platform-drivers-x86 maintainer and tree

Hans de Goede (1):
      Revert "ideapad-laptop: Disable touchpad interface on Yoga models"

Mathias Krause (1):
      ideapad-laptop: Constify DMI table for real!

 MAINTAINERS                           |  4 ++--
 drivers/platform/x86/ideapad-laptop.c | 31 ++-----------------------------
 drivers/platform/x86/toshiba_acpi.c   | 27 ++++++++++++++++++++-------
 3 files changed, 24 insertions(+), 38 deletions(-)
