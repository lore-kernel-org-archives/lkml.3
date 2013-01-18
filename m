Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3ARK3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:29:51 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:52149 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072Ab3ARK3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:29:50 -0500
Message-ID: <1358504987.8203.425.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: [GIT PULL] EFI fixes for v3.8
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 18 Jan 2013 10:29:47 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.8

for you to fetch changes up to 791eb564d218dabe0f9a2212916fe54240b97afb:

  efivarfs: Delete dentry from dcache in efivarfs_file_write() (2013-01-18 09:43:44 +0000)

----------------------------------------------------------------
EFI fixes for v3.8

  * Fix EFI boot crash on machines with > 512GB of RAM
  * Fix a few oopses in efivarfs

----------------------------------------------------------------
Lingzhu Xiang (1):
      efivarfs: Drop link count of the right inode

Matt Fleming (2):
      efivarfs: Never return ENOENT from firmware
      efivarfs: Delete dentry from dcache in efivarfs_file_write()

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

 arch/x86/platform/efi/efi_64.c | 22 +++++++++++++++++-----
 drivers/firmware/efivars.c     |  5 +++--
 2 files changed, 20 insertions(+), 7 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center

