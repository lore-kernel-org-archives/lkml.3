Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3J0Uqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 16:46:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44383 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab3J0Uqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:46:51 -0400
Date: Sun, 27 Oct 2013 20:46:48 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131027204648.GG1982@console-pimps.org>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
 <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
 <20131026101055.GB14949@gmail.com>
 <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
 <20131027070035.GB28433@gmail.com>
 <20131027110148.GA24817@pd.tnic>
 <20131027202215.GD1982@console-pimps.org>
 <20131027203409.GC24817@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027203409.GC24817@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct, at 09:34:09PM, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 08:22:15PM +0000, Matt Fleming wrote:
> > I've certainly no problem with moving it under drivers/firmware/efi/,
> > but please don't create a new subdirectory in drivers/ just for this.
> 
> Yeah, no - we have an subdir for this - drivers/firmware/efi/ so no need
> for the drivers/u?efi thing.
> 
> My train of thought here is, we want to put all firmware-related crap
> into drivers/firmware/ and since CPER is from the UEFI spec, it should
> go into drivers/firmware/efi.
 
Makes total sense to me.

> I guess we can apply that same logic to the remaining UEFI sh*tstorm
> coming our way.

;-)

-- 
Matt Fleming, Intel Open Source Technology Center
