Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3J0LBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:01:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51721 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3J0LBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:01:53 -0400
Date: Sun, 27 Oct 2013 12:01:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>, Matt Fleming <matt@console-pimps.org>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131027110148.GA24817@pd.tnic>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
 <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
 <20131026101055.GB14949@gmail.com>
 <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
 <20131027070035.GB28433@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131027070035.GB28433@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:00:35AM +0100, Ingo Molnar wrote:
> 
> * Tony Luck <tony.luck@gmail.com> wrote:
> 
> > > Hm, I'm not sure we should move something named after a hardware 
> > > feature into lib/. It's not really generic C library functionality,
> >
> > 
> > Not a hardware feature. CPER stands for Common Platform Error Record 
> > from the UEFI standard. [...]
> 
> By all means UEFI can be considered platform dependent at the moment:
> 
>   comet:~/tip> git grep -i uefi arch/arm/
>   comet:~/tip> git grep -i uefi arch/arm64/
>   comet:~/tip> git grep -i uefi arch/powerpc/
>   comet:~/tip> git grep -i uefi arch/mips/
>   comet:~/tip> 
> 
> If a committee says that a name of some standard is 'common platform' does 
> not make it so. lib/ is mostly kept for mathematical, C-library alike 
> functionality you see in CS textbooks.
> 
> > As Chen Gong points out, drivers/acpi isn't the right place ... so if 
> > not lib/ ... then where?
> 
> drivers/uefi/?

Hmm, we do have drivers/firmware/, even drivers/firmware/efi/ subdir and
since this thing is part of the UEFI spec, we probably should stick it
there...

Matt, heads up^^^.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
