Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3LPXgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:36:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44150 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab3LPXgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:36:43 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 0/3] EFI memmap fix
Date: Tue, 17 Dec 2013 00:36:34 +0100
Message-Id: <1387236997-26975-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi guys,

this is the result of Toshi and me debugging a #GP on one of his big HP
boxes sporting UEFI. Each commit message should be self-explanatory so
please look there.

This has more or less an RFC nature thus I'm sending it now to collect
feedback. It is going to wait in the EFI queue anyway after the kexec
stuff gets sorted out first.

Comments and suggestions as always are very much appreciated.

Thanks.

Borislav Petkov (3):
  x86, ptdump: Add the functionality to dump an arbitrary pagetable
  efi: Dump the EFI page table
  efi: Make efi virtual runtime map passing more robust

 arch/x86/include/asm/pgtable.h |  3 +-
 arch/x86/mm/dump_pagetables.c  | 77 ++++++++++++++++++++++++++++--------------
 arch/x86/platform/efi/efi.c    | 68 ++++++++++++++++++++++++++++++++-----
 3 files changed, 112 insertions(+), 36 deletions(-)

-- 
1.8.4

