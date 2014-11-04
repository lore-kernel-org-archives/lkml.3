Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaKDGih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:38:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaKDGig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:38:36 -0500
Date: Mon, 3 Nov 2014 22:38:31 -0800
From: Darren Hart <dvhart@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] platform-drivers-x86 for 3.18-2
Message-ID: <20141104063830.GD56751@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A short list of patches applying quirks and new DMI matches. These pass my basic
build tests and have spent 4 days in linux-next.

Thanks,

Darren Hart
Intel Open Source Technology Center

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git tags/platform-drivers-x86-v3.18-2

for you to fetch changes up to 725c7f619e20f5051bba627fca11dc107c2a93b1:

  quirk for Lenovo Yoga 3: no rfkill switch (2014-10-27 21:45:13 -0700)

----------------------------------------------------------------
platform-drivers-x86 for 3.18-2

Quirks and DMI match additions.

----------------------------------------------------------------
Aaron Lu (1):
      toshiba_acpi: Add Toshiba TECRA A50-A to the alt keymap dmi list

Hans de Goede (2):
      samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
      acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80

Stanislaw Gruszka (1):
      asus-nb-wmi: Add wapf4 quirk for the X550VB

Stephan Mueller (1):
      quirk for Lenovo Yoga 3: no rfkill switch

 drivers/platform/x86/acer-wmi.c       | 11 +++++++++++
 drivers/platform/x86/asus-nb-wmi.c    |  9 +++++++++
 drivers/platform/x86/ideapad-laptop.c |  7 +++++++
 drivers/platform/x86/samsung-laptop.c | 10 ++++++++++
 drivers/platform/x86/toshiba_acpi.c   |  6 ++++++
 5 files changed, 43 insertions(+)
-- 
Darren Hart
Intel Open Source Technology Center
