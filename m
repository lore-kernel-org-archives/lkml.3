Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3J0UWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 16:22:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50107 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058Ab3J0UWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:22:19 -0400
Date: Sun, 27 Oct 2013 20:22:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131027202215.GD1982@console-pimps.org>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
 <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
 <20131026101055.GB14949@gmail.com>
 <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
 <20131027070035.GB28433@gmail.com>
 <20131027110148.GA24817@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027110148.GA24817@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct, at 12:01:48PM, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 08:00:35AM +0100, Ingo Molnar wrote:
> > 
> > * Tony Luck <tony.luck@gmail.com> wrote:
> > 
> > > > Hm, I'm not sure we should move something named after a hardware 
> > > > feature into lib/. It's not really generic C library functionality,
> > >
> > > 
> > > Not a hardware feature. CPER stands for Common Platform Error Record 
> > > from the UEFI standard. [...]
> > 
> > By all means UEFI can be considered platform dependent at the moment:
> > 
> >   comet:~/tip> git grep -i uefi arch/arm/
> >   comet:~/tip> git grep -i uefi arch/arm64/
> >   comet:~/tip> git grep -i uefi arch/powerpc/
> >   comet:~/tip> git grep -i uefi arch/mips/
> >   comet:~/tip> 
> > 
> > If a committee says that a name of some standard is 'common platform' does 
> > not make it so. lib/ is mostly kept for mathematical, C-library alike 
> > functionality you see in CS textbooks.
> > 
> > > As Chen Gong points out, drivers/acpi isn't the right place ... so if 
> > > not lib/ ... then where?
> > 
> > drivers/uefi/?
> 
> Hmm, we do have drivers/firmware/, even drivers/firmware/efi/ subdir and
> since this thing is part of the UEFI spec, we probably should stick it
> there...

I've certainly no problem with moving it under drivers/firmware/efi/,
but please don't create a new subdirectory in drivers/ just for this.

-- 
Matt Fleming, Intel Open Source Technology Center
