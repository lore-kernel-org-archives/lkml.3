Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3JDTz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:55:56 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35524 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab3JDTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:55:54 -0400
Date: Fri, 4 Oct 2013 20:55:50 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes
Message-ID: <20131004195550.GA21783@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes fix a couple of sparse warnings introduced in the last
pull.

The following changes since commit 0ce6cda2c75d64175394341ef60e6e1d27dd9c10:

  x86 efi: bugfix interrupt disabling sequence (2013-09-30 10:23:11 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:

  boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)

----------------------------------------------------------------
 * Fix a recently introduced sparse warning caused by using 0 instead of
   NULL - Leif Lindholm

 * Remove a useless memset from the common EFI stub code - Roy Franz

----------------------------------------------------------------
Leif Lindholm (1):
      x86/efi: Fix config_table_type array termination

Roy Franz (1):
      boot, efi: Remove redundant memset()

 arch/x86/platform/efi/efi.c            | 2 +-
 drivers/firmware/efi/efi-stub-helper.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
