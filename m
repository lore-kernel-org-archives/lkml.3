Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbaICNfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:35:15 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:52752 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbaICNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:35:08 -0400
Date: Wed, 3 Sep 2014 14:35:03 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: mingo@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com
Subject: Re: [PATCH v2 0/5] beautify EFI memmap logs
Message-ID: <20140903133503.GF3001@console-pimps.org>
References: <1409743943-16934-1-git-send-email-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409743943-16934-1-git-send-email-lersek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep, at 01:32:18PM, Laszlo Ersek wrote:
> changes in v2:
> - explain with examples how the log's appearance changes, in patches 3-5
>   [Ingo]
> 
> v1 blurb:
> 
> > It's a pain to analyze EFI memmap logs while debugging, especially to
> > verify the memory types (an enum) and the memory attributes (a
> > bitmap). This series renders those columns human-readable, and unifies
> > their formatting between x86, ia64 and arm64.
> 
> Thanks
> Laszlo
> 
> Laszlo Ersek (5):
>   efi: add macro for EFI_MEMORY_UCE memory attribute
>   efi: introduce efi_md_typeattr_format()
>   x86: efi: format EFI memory type & attrs with efi_md_typeattr_format()
>   ia64: efi: format EFI memory type & attrs with
>     efi_md_typeattr_format()
>   arm64: efi: format EFI memory type & attrs with
>     efi_md_typeattr_format()
> 
>  include/linux/efi.h         |  8 +++++++
>  arch/arm64/kernel/efi.c     | 26 +++++----------------
>  arch/ia64/kernel/efi.c      |  6 +++--
>  arch/x86/platform/efi/efi.c |  7 ++++--
>  drivers/firmware/efi/efi.c  | 57 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 80 insertions(+), 24 deletions(-)

Thanks Laszlo, applied to the 'next' branch with Ard's Tested-by and
Acked-by tags.

-- 
Matt Fleming, Intel Open Source Technology Center
