Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3IJQzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:55:15 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:42057 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3IJQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:55:14 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2013 12:55:13 EDT
Date: Tue, 10 Sep 2013 18:48:18 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: [GIT PULL] CRIS updates for 3.12
Message-ID: <20130910164818.GJ32443@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

Please pull for CRIS Linux 3.12 updates.
Mostly cleanup and removal of unused configs.

Thanks!

The following changes since commit 2e032852245b3dcfe5461d7353e34eb6da095ccf:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2013-09-05 18:07:32 -0700)

are available in the git repository at:


  git://jni.nu/cris tags/cris-for-3.12

for you to fetch changes up to be8cb7f42ab9a8723082daa83ac28a11d4dde942:

  CRIS: drop unused Kconfig symbols (2013-09-10 17:38:07 +0200)

----------------------------------------------------------------
CRIS changes for 3.12

----------------------------------------------------------------
Jesper Nilsson (2):
      CRIS: remove unused current_regs
      CRIS: Add kvm_para.h which includes generic file

Paul Bolle (3):
      CRIS: remove "config OOM_REBOOT"
      CRIS: Remove last traces of legacy RTC drivers
      CRIS: drop unused Kconfig symbols

 arch/cris/Kconfig                     |  81 -------
 arch/cris/arch-v10/drivers/Kconfig    |  70 ------
 arch/cris/arch-v10/drivers/Makefile   |   2 -
 arch/cris/arch-v32/drivers/Kconfig    | 394 ----------------------------------
 arch/cris/arch-v32/mach-a3/Kconfig    |   4 -
 arch/cris/include/asm/processor.h     |   1 -
 arch/cris/include/uapi/asm/kvm_para.h |   1 +
 7 files changed, 1 insertion(+), 552 deletions(-)
 create mode 100644 arch/cris/include/uapi/asm/kvm_para.h

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
