Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaDVXbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:31:21 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37391 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaDVXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:31:19 -0400
Date: Tue, 22 Apr 2014 16:31:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/vdso fix for v3.15-rc3
In-Reply-To: <201404211901.s3LJ1Cra010895@terminus.zytor.com>
Message-ID: <alpine.DEB.2.02.1404221631001.31560@chino.kir.corp.google.com>
References: <201404211901.s3LJ1Cra010895@terminus.zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014, H. Peter Anvin wrote:

> Hi Linus,
> 
> This is a single build fix for building with gold as opposed to GNU
> ld.  It got queued up separately and was expected to be pushed during
> the merge window, but it got left behind.
> 
> The following changes since commit 37c975545ec63320789962bf307f000f08fabd48:
> 
>   x86, vdso: Fix the symbol versions on the 32-bit vDSO (2014-03-30 10:08:38 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus
> 
>   x86, vdso: Make the vdso linker script compatible with Gold (2014-04-03 12:03:59 -0700)
> 
> ----------------------------------------------------------------
> Andy Lutomirski (1):
>       x86, vdso: Make the vdso linker script compatible with Gold
> 

Building with gold works perfectly now, thanks Peter and Andy!
