Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaKPJuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:50:04 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49689 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaKPJuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:50:00 -0500
Date: Sun, 16 Nov 2014 10:49:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes for v3.19
Message-ID: <20141116094955.GA20154@gmail.com>
References: <20141114214223.GA6810@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114214223.GA6810@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Folks,
> 
> Please queue up the following changes for v3.19. 
> 
> Inclued are two straight forward changes from Mathias, and another
> attempt from Ard at moving the x86 EFI boot stub to the libstub library.
> 
> It would be great to get these baking in linux-next for a bit.
> 
> The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:
> 
>   Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> 
> for you to fetch changes up to 8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e:
> 
>   x86, ptdump: Add section for EFI runtime services (2014-11-11 22:28:57 +0000)
> 
> ----------------------------------------------------------------
>  * Support module unload for efivarfs - Mathias Krause
> 
>  * Another attempt at moving x86 to libstub taking advantage of the
>    __pure attribute - Ard Biesheuvel
> 
>  * Add EFI runtime services section to ptdump - Mathias Krause
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (1):
>       efi/x86: Move x86 back to libstub
> 
> Mathias Krause (2):
>       efivarfs: Allow unloading when build as module
>       x86, ptdump: Add section for EFI runtime services
> 
>  arch/x86/boot/compressed/Makefile       |  3 ++-
>  arch/x86/boot/compressed/eboot.c        |  8 ++++----
>  arch/x86/boot/compressed/eboot.h        | 16 ----------------
>  arch/x86/include/asm/efi.h              | 24 ++++++++++++++++++++++++
>  arch/x86/include/asm/pgtable_64_types.h |  2 ++
>  arch/x86/mm/dump_pagetables.c           |  3 +++
>  arch/x86/platform/efi/efi_64.c          |  3 +--
>  drivers/firmware/efi/Makefile           |  2 +-
>  fs/efivarfs/super.c                     | 11 +++++++++--
>  9 files changed, 46 insertions(+), 26 deletions(-)

Pulled into tip:x86/efi, thanks Matt!

	Ingo
