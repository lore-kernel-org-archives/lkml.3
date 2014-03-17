Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaCQWbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:31:39 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41394 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbaCQWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:31:37 -0400
Date: Mon, 17 Mar 2014 22:31:31 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.15
Message-ID: <20140317223131.GB2815@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I've queued up a few fixes that avoid some crashes when running with
CONFIG_EFI_MIXED. Please pull into the queue for the merge window.

The following changes since commit 617b3c37da78cb89c63ed880b2405afc7490567b:

  Merge branch 'mixed-mode' into efi-for-mingo (2014-03-05 18:18:50 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 9a11040ff962304c1838aa9a9f33be78784eae47:

  x86/efi: Restore 'attr' argument to query_variable_info() (2014-03-17 21:55:04 +0000)

----------------------------------------------------------------
 * Save and restore the segment registers when thunking

 * Correct arguments to query_variable_info() when thunking

 * Delete the dead code phys_efi_get_time()

----------------------------------------------------------------
Matt Fleming (3):
      x86/efi: Preserve segment registers in mixed mode
      x86/efi: Rip out phys_efi_get_time()
      x86/efi: Restore 'attr' argument to query_variable_info()

 arch/x86/platform/efi/efi.c         | 29 -----------------------------
 arch/x86/platform/efi/efi_64.c      |  2 +-
 arch/x86/platform/efi/efi_stub_64.S | 25 +++++++++++++++++--------
 3 files changed, 18 insertions(+), 38 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
