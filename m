Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaIXNS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:18:26 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39293 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaIXNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:18:25 -0400
Date: Wed, 24 Sep 2014 14:18:22 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140924131822.GN18635@console-pimps.org>
References: <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <542182E0.6090101@canonical.com>
 <20140923143712.GI18635@console-pimps.org>
 <20140924072633.GA1768@gmail.com>
 <20140924114236.GM18635@console-pimps.org>
 <20140924130816.GB3277@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924130816.GB3277@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep, at 03:08:16PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > +/*
> > + * There's no way to return an informative status from this function,
> > + * because any analysis (and printing of error messages) needs to be
> > + * done directly at the EFI function call-site.
> > + *
> > + * For example, EFI_INVALID_PARAMETER could indicate a bug or maybe we
> > + * just didn't find any PCI devices, but there's no way to tell outside
> > + * the context of the call.
> > + */
> > +static void setup_efi_pci(struct boot_params *params)
> 
> Btw., do we print proper complaints at the EFI call sites if such 
> failures do happen (and if that failure is unexpected/bad)?

Not yet, but I've got a patch queued up for v3.18 that does this.

-- 
Matt Fleming, Intel Open Source Technology Center
