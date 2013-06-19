Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3FSNEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:04:39 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63684 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3FSNEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:04:38 -0400
Date: Wed, 19 Jun 2013 15:04:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619130434.GB24957@gmail.com>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619130225.GA28311@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Jun 19, 2013 at 02:52:43PM +0200, Ingo Molnar wrote:
> > I hope making it a weird boot option is not the end plan, there's
> > little point in _not_ enabling 1:1 mappings by default eventually:
> > the 1:1 mapping is supposed to emulate a "Windows compatible" EFI
> > environment better and is expected to work around certain EFI runtime
> > crashes.
> 
> And yet there are the Macs which reportedly cannot stomach this.

Do we know why?

> And then there's the issue where some boxes cannot boot through the EFI 
> stub with those patches even without "efi=1:1_map" on the command line. 
> The issue has something to do with the "cmpb $0, efi_use_11_map" in the 
> efi_callX stubs.

A bug I suspect?

> And then again, other boxes have no problem with it and boot perfectly 
> fine.
> 
> So I don't know - it all looks like a weird boot, opt-in option for now.

But once it works reliably we can enable it, right?

Thanks,

	Ingo
