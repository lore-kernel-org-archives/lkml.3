Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab3DXK3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:29:07 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42809 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab3DXK3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:29:05 -0400
Message-ID: <5177B3EC.2040502@intel.com>
Date: Wed, 24 Apr 2013 11:29:00 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] x86, efi: Fix a build warning
References: <1366798154-1380-1-git-send-email-bp@alien8.de>
In-Reply-To: <1366798154-1380-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 11:09, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Fix this:
> 
> arch/x86/boot/compressed/eboot.c: In function ‘setup_efi_vars’:
> arch/x86/boot/compressed/eboot.c:269:2: warning: passing argument 1 of ‘efi_call_phys’ makes pointer from integer without a cast [enabled by default]
> In file included from arch/x86/boot/compressed/eboot.c:12:0:
> /w/kernel/linux/arch/x86/include/asm/efi.h:8:33: note: expected ‘void *’ but argument is of type ‘long unsigned int’
> 
> after cc5a080c5d40 ("efi: Pass boot services variable info to runtime
> code").
> 
> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/boot/compressed/eboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied!
