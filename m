Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3J1QA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:00:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54031 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab3J1QA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:00:56 -0400
Date: Mon, 28 Oct 2013 17:00:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131028160053.GO4314@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131028112246.GK1982@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131028112246.GK1982@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:22:46AM +0000, Matt Fleming wrote:
> Could you use the efi_enabled() function to test for EFI_OLD_MEMMAP
> instead of test_bit()?

Sure.

> This way we won't exhaust the bitspace quite so soon (since ARM/ARM64

Yeah, very foresightful.

> can reuse EFI_ARCH_1 if they need it), plus this memory mapping method
> is a very architecture-specific thing and so makes sense to hide it in
> the bowels of arch/x86. If it turns out that ARM/ARM64 need the exact
> same config option we can delete EFI_ARCH_1 and move EFI_OLD_MEMMAP to
> include/linux/efi.h just like in your original patch. 
> 
> What do you think?

Yep, done and pushed out.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
