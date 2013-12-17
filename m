Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3LQBQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:16:51 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:6270 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3LQBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:16:50 -0500
Message-ID: <1387242704.21140.44.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/3] EFI memmap fix
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 16 Dec 2013 18:11:44 -0700
In-Reply-To: <1387236997-26975-1-git-send-email-bp@alien8.de>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 00:36 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Hi guys,
> 
> this is the result of Toshi and me debugging a #GP on one of his big HP
> boxes sporting UEFI. Each commit message should be self-explanatory so
> please look there.
> 
> This has more or less an RFC nature thus I'm sending it now to collect
> feedback. It is going to wait in the EFI queue anyway after the kexec
> stuff gets sorted out first.
> 
> Comments and suggestions as always are very much appreciated.
> 
> Thanks.
> 
> Borislav Petkov (3):
>   x86, ptdump: Add the functionality to dump an arbitrary pagetable
>   efi: Dump the EFI page table
>   efi: Make efi virtual runtime map passing more robust
> 
>  arch/x86/include/asm/pgtable.h |  3 +-
>  arch/x86/mm/dump_pagetables.c  | 77 ++++++++++++++++++++++++++++--------------
>  arch/x86/platform/efi/efi.c    | 68 ++++++++++++++++++++++++++++++++-----
>  3 files changed, 112 insertions(+), 36 deletions(-)
> 

Thanks for the quick turnaround!  For the series:

Tested-by: Toshi Kani <toshi.kani@hp.com>

Toshi

