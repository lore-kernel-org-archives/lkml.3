Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaCDXr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:47:56 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:55162 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbaCDXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:47:54 -0500
Date: Tue, 4 Mar 2014 23:47:47 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20140304234747.GD17362@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following fix from Borislav that fixes a boot regression
for SGI UV.

The following changes since commit 09503379dc99535b1bbfa51aa1aeef340f5d82ec:

  x86/efi: Check status field to validate BGRT header (2014-02-14 10:07:15 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a5d90c923bcfb9632d998ed06e9569216ad695f3:

  x86/efi: Quirk out SGI UV (2014-03-04 23:43:33 +0000)

----------------------------------------------------------------
 * Disable the new EFI 1:1 virtual mapping for SGI UV because using it
   causes a crash during boot - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Quirk out SGI UV

 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     | 10 ++--------
 arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+), 8 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
