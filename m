Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3ITKCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:02:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34680 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3ITKCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:02:16 -0400
Date: Fri, 20 Sep 2013 12:02:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20130920100210.GC9574@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920090544.GA9574@pd.tnic>
 <20130920094913.GG4785@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130920094913.GG4785@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:49:13AM +0100, Matt Fleming wrote:
> /home/build/git/efi/arch/x86/platform/efi/efi.c: In function ‘__map_region’:
> /home/build/git/efi/arch/x86/platform/efi/efi.c:753:24: error: ‘struct real_mode_header’ has no member named ‘trampoline_pgd’
> /home/build/git/efi/arch/x86/platform/efi/efi.c: In function ‘efi_enter_virtual_mode’:
> /home/build/git/efi/arch/x86/platform/efi/efi.c:863:64: error: ‘struct real_mode_header’ has no member named ‘trampoline_pgd’
> /home/build/git/efi/arch/x86/platform/efi/efi.c:867:2: error: implicit declaration of function ‘efi_sync_low_kernel_mappings’
> [-Werror=implicit-function-declaration]

Yep, I know - saw them last night and fixed them. But this place will
need some reorg anyway in the next version - just don't do 32-bit builds
with this one :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
