Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3CAUtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:49:25 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47340 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3CAUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:49:23 -0500
Message-ID: <1362170960.2842.462.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86, efi: Make efi_memblock_x86_reserve_range more
 readable
From: Matt Fleming <matt.fleming@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Date: Fri, 01 Mar 2013 20:49:20 +0000
In-Reply-To: <1362154064-9386-1-git-send-email-bp@alien8.de>
References: <1362154064-9386-1-git-send-email-bp@alien8.de>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 17:07 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> So basically this function copies EFI memmap stuff from boot_params into
> the EFI memmap descriptor and reserves memory for it. Make it much more
> readable.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/platform/efi/efi.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

Thanks, applied!


