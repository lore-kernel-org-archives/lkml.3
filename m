Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3LQO24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:28:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38425 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab3LQO2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:28:54 -0500
Date: Tue, 17 Dec 2013 15:28:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Message-ID: <20131217142849.GE30592@pd.tnic>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
 <20131217121024.GB3145@console-pimps.org>
 <20131217134006.GC30592@pd.tnic>
 <20131217135156.GC3145@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131217135156.GC3145@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 01:51:56PM +0000, Matt Fleming wrote:
> Couldn't we do the mapping in efi_setup_page_tables() if we pass
> __pa(new_memmap) and 1 << new_memmap_shift as arguments?

Yep, not a bad idea. I'll give it a try.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
