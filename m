Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbbARMFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:05:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbbARMFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:05:07 -0500
Date: Sun, 18 Jan 2015 13:05:03 +0100
From: Borislav Petkov <bp@suse.de>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCHv2 0/4] x86, entry: some cleanup and simplification...
Message-ID: <20150118120503.GA3424@pd.tnic>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 18, 2015 at 12:45:16PM +0100, Alexander van Heukelum wrote:
> Hi Andy,
> 
> The last patchset did not compile on i386. Please ignore it. This one
> should be better. Instead of removing KERNEL_STACK_OFFSET, it is now
> used consistently on both i386 and x86_64.
> 
> Boot tested using qemu (using klibc for userspace)
> 	- x86_64, 32-bit userspace, core2duo (sysenter32)
> 	- x86_64, 32-bit userspace, phenom (syscall32)
> 	- x86_64, 32-bit userspace, vdso=0 (int 0x80)
> 	- x86_64, 64-bit userspace
> 	- i386, pentium3 (sysenter)
> 	- i386, athlon (syscall)
> 	- i386, vdso=0 (int 0x80)
> 
> They were tested on top of 22f2aa4a0361707a5cfb1de9d45260b39965dead
> (x86/entry-devel in your tree) and this kernel is now running on my
> laptop.

btw, you might wanna sync with Denys who's doing cleanups in that area too:

https://lkml.kernel.org/r/1421272101-16847-1-git-send-email-dvlasenk@redhat.com

and touching some of the stuff you're changing too.

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
