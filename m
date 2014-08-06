Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaHFJq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:46:56 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61632 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaHFJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:46:55 -0400
Date: Wed, 6 Aug 2014 10:46:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20140806094651.GU15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks, please pull the following fix. It's something that Peter and I
talked about a while ago, and it seems that people are actually hitting
issues without this patch and have been since v3.13.

The following changes since commit c7fb93ec51d462ec3540a729ba446663c26a0505:

  x86/efi: Include a .bss section within the PE/COFF headers (2014-07-10 14:21:39 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 7b2a583afb4ab894f78bc0f8bd136e96b6499a7e:

  x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub (2014-08-05 22:01:04 +0100)

----------------------------------------------------------------
 * Enforce CONFIG_RELOCATABLE for the x86 EFI boot stub, otherwise
   it's possible to overwrite random pieces of unallocated memory during
   kernel decompression, leading to machine resets.

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
Matt Fleming, Intel Open Source Technology Center
