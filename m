Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3J2ISt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:18:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50456 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab3J2ISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:18:47 -0400
Date: Tue, 29 Oct 2013 08:18:43 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes
Message-ID: <20131029081843.GQ1982@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I dropped the cleanup patch which was causing build issues for ARM.

The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:

  boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 72548e836b0c4abbb652e791dee9c91203a9a4c6:

  x86/efi: Add EFI framebuffer earlyprintk support (2013-10-28 18:09:58 +0000)

----------------------------------------------------------------
 * Add support for earlyprintk=efi which uses the EFI framebuffer. Very
   useful for debugging boot issues.

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/x86/Kconfig.debug               |  10 ++
 arch/x86/include/asm/efi.h           |   2 +
 arch/x86/kernel/early_printk.c       |   7 ++
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 6 files changed, 216 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/platform/efi/early_printk.c

-- 
Matt Fleming, Intel Open Source Technology Center
