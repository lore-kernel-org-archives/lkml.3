Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3J2IMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:12:06 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52452 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3J2IL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:11:59 -0400
Date: Tue, 29 Oct 2013 09:11:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes
Message-ID: <20131029081156.GB16557@gmail.com>
References: <20131028123528.GM1982@console-pimps.org>
 <20131028134413.GA10163@gmail.com>
 <20131028155215.GN1982@console-pimps.org>
 <20131028155525.GA13987@gmail.com>
 <20131028203052.GO1982@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028203052.GO1982@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> On Mon, 28 Oct, at 04:55:25PM, Ingo Molnar wrote:
> > 
> > * Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > > On Mon, 28 Oct, at 02:44:13PM, Ingo Molnar wrote:
> > > > and this breaks the ARM build:
> > > > 
> > > > In file included from /home/mingo/tip/init/main.c:44:
> > > > /home/mingo/tip/include/linux/efi.h:842:21: error: asm/efi.h: No such file or directory
> > > > /home/mingo/tip/init/main.c: In function 'start_kernel':
> > > > /home/mingo/tip/init/main.c:638: error: implicit declaration of function 'efi_enabled'
> > > > /home/mingo/tip/init/main.c:639: error: implicit declaration of function 'efi_late_init'
> > > > /home/mingo/tip/init/main.c:640: error: implicit declaration of function 'efi_free_boot_services'
> > > 
> > > Ah, that's my own fault because my 'next' branch doesn't include 
> > > the ARM EFI support. Where did you get the patches from? Are they 
> > > in linux-next?
> > 
> > It's all in tip:x86/efi.
> > 
> > > I'm inclined to drop the cleanup patch for now and do it later, 
> > > once things have settled because it's also causing conflicts for 
> > > Borislav's work.
> > 
> > Sure.
> 
> OK, I've pushed out the 'next' branch and retagged it as 'efi-next'
> (again), which hopefully should be finally free from build errors.

Please send it out as a new pull requests so that the diffstat and 
shortlog can be seen and double checked, etc.

Thanks,

	Ingo
