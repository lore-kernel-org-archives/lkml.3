Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3GKLQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:16:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47201 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932127Ab3GKLQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:16:21 -0400
Date: Thu, 11 Jul 2013 12:16:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fixes
Message-ID: <20130711111618.GP12287@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d128e1e72bf082542e85f72e6b7ddd704193588:

  Revert "Makefile: Fix install error with make -j option" (2013-07-10 19:02:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 8216a67eb5e92224b4509b7f55ec4891c9021fdb:

  Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()" (2013-07-11 11:00:32 +0100)

----------------------------------------------------------------
 * Revert Matthew Garrett's patch that avoids passing EFI Boot Services
   regions to SetVirtualAddressMap(). It caused boot regressions.

 * Fix a crash in the efivars code by checking whether that EFI Runtime
   Services are available before attempting to use them.

----------------------------------------------------------------
Matt Fleming (2):
      efivars: check for EFI_RUNTIME_SERVICES
      Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"

 arch/x86/platform/efi/efi.c    | 7 -------
 drivers/firmware/efi/efivars.c | 3 +++
 2 files changed, 3 insertions(+), 7 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
