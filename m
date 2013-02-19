Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab3BSPhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:37:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48455 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab3BSPg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:36:59 -0500
Date: Tue, 19 Feb 2013 16:36:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v3.9
Message-ID: <20130219153655.GD26748@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130219152503.GA14862@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130219152503.GA14862@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 04:25:03PM +0100, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-cpu-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus
> 
>    HEAD: f0322bd341fd63261527bf84afd3272bcc2e8dd3 x86, AMD: Enable WC+ memory type on family 10 processors
> 
> The biggest change is the enabling of the WC+ memory type on 
> family 10 processors. (This is a BIOS bug workaround in essence: 
> if the BIOS fails to do this then we fall back to uncacheable, 
> degrading performance, for example for virtualized guests using 
> nested pages.)
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Boris Ostrovsky (2):
>       x86, AMD: Clean up init_amd()
>       x86, AMD: Enable WC+ memory type on family 10 processors

Those kill a kvm guest with a #GP. Can we apply the fix for it too pls?

http://marc.info/?l=linux-kernel&m=136077007423065&w=2

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
