Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaATNlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:41:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44093 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaATNle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:41:34 -0500
Date: Mon, 20 Jan 2014 14:41:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 2/5] efi: Dump the EFI page table
Message-ID: <20140120134121.GC3003@pd.tnic>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-3-git-send-email-bp@alien8.de>
 <20140120133802.GA684@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140120133802.GA684@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 01:38:02PM +0000, Matt Fleming wrote:
> > +config EFI_PGT_DUMP
> > +	bool "Dump the EFI pagetable"
> > +	depends on EFI && X86_PTDUMP
> > +	---help---
> > +	  Enable this if you want to dump the EFI page table before
> > +	  enabling virtual mode. This can be used to debug miscellaneous
> > +	  issues with the mapping of the EFI runtime regions into that
> > +	  table.
> > +
> 
> Would this be more suitable in arch/x86/Kconfig.debug?

I wanted to keep it close to CONFIG_EFI if we decide to make EFI into a
menu some day but I don't have a strong preference.

Just move it when applying.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
