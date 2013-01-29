Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3A2TDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:03:51 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:51070 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab3A2TDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:03:49 -0500
Message-ID: <1359486226.8282.97.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] EFI fixes for v3.8
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 29 Jan 2013 19:03:46 +0000
In-Reply-To: <1358504987.8203.425.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1358504987.8203.425.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git 

for you to fetch changes up to 739701888f5d98010a8960b2d974d74c77c830a2:

  x86, efi: remove attribute check from setup_efi_pci (2013-01-29 17:52:06 +0000)

----------------------------------------------------------------
Various urgent EFI fixes and some warning cleanups for v3.8

  * EFI boot stub fix for Macbook Pro's from Maarten Lankhorst
  * Fix an oops in efivarfs from Lingzhu Xiang
  * 32-bit warning cleanups from Jan Beulich
  * Patch to Boot on >512GB RAM systems from Nathan Zimmer
  * Set efi.runtime_version correctly
  * efivarfs updates

----------------------------------------------------------------
Jan Beulich (1):
      x86, efi: fix 32-bit warnings in setup_efi_pci()

Lingzhu Xiang (1):
      efivarfs: Drop link count of the right inode

Maarten Lankhorst (1):
      x86, efi: remove attribute check from setup_efi_pci

Matt Fleming (3):
      efivarfs: Never return ENOENT from firmware
      efivarfs: Delete dentry from dcache in efivarfs_file_write()
      x86, efi: Set runtime_version to the EFI spec revision

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

 arch/x86/boot/compressed/eboot.c | 11 ++++-------
 arch/x86/platform/efi/efi.c      |  2 +-
 arch/x86/platform/efi/efi_64.c   | 22 +++++++++++++++++-----
 drivers/firmware/efivars.c       |  5 +++--
 4 files changed, 25 insertions(+), 15 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center

