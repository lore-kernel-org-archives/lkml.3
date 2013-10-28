Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3J1Ua7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:30:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49780 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab3J1Ua5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:30:57 -0400
Date: Mon, 28 Oct 2013 20:30:52 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes
Message-ID: <20131028203052.GO1982@console-pimps.org>
References: <20131028123528.GM1982@console-pimps.org>
 <20131028134413.GA10163@gmail.com>
 <20131028155215.GN1982@console-pimps.org>
 <20131028155525.GA13987@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028155525.GA13987@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct, at 04:55:25PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > On Mon, 28 Oct, at 02:44:13PM, Ingo Molnar wrote:
> > > and this breaks the ARM build:
> > > 
> > > In file included from /home/mingo/tip/init/main.c:44:
> > > /home/mingo/tip/include/linux/efi.h:842:21: error: asm/efi.h: No such file or directory
> > > /home/mingo/tip/init/main.c: In function 'start_kernel':
> > > /home/mingo/tip/init/main.c:638: error: implicit declaration of function 'efi_enabled'
> > > /home/mingo/tip/init/main.c:639: error: implicit declaration of function 'efi_late_init'
> > > /home/mingo/tip/init/main.c:640: error: implicit declaration of function 'efi_free_boot_services'
> > 
> > Ah, that's my own fault because my 'next' branch doesn't include 
> > the ARM EFI support. Where did you get the patches from? Are they 
> > in linux-next?
> 
> It's all in tip:x86/efi.
> 
> > I'm inclined to drop the cleanup patch for now and do it later, 
> > once things have settled because it's also causing conflicts for 
> > Borislav's work.
> 
> Sure.

OK, I've pushed out the 'next' branch and retagged it as 'efi-next'
(again), which hopefully should be finally free from build errors.

-- 
Matt Fleming, Intel Open Source Technology Center
