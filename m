Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3KKU7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:59:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38321 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3KKU7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:59:02 -0500
Date: Mon, 11 Nov 2013 21:58:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH -v1.1] Kbuild: Ignore GREP_OPTIONS env variable
Message-ID: <20131111205837.GA29793@pd.tnic>
References: <20131030160635.GE13290@pd.tnic>
 <527AB7D1.9080307@suse.cz>
 <20131111142743.GE28219@pd.tnic>
 <20131111170041.GA18517@pobox.suse.cz>
 <20131111204330.GC18886@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131111204330.GC18886@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 09:43:30PM +0100, Ingo Molnar wrote:
> * Michal Marek <mmarek@suse.cz> wrote:
> > On Mon, Nov 11, 2013 at 03:27:43PM +0100, Borislav Petkov wrote:
> > > From: Borislav Petkov <bp@suse.de>
> > > Subject: [PATCH] Kbuild: Ignore GREP_OPTIONS env variable
> > > 
> > > When building the kernel in a shell which defines GREP_OPTIONS so that
> > > grep behavior is modified, we can break the generation of the syscalls
> > > table like so:
> > > 
> > > __SYSCALL_COMMON([01;31m[K0[m[K, sys_read, sys_read)
> > > __SYSCALL_COMMON([01;31m[K1[m[K, sys_write, sys_write)
> > > __SYSCALL_COMMON([01;31m[K1[m[K0, sys_mprotect, sys_mprotect) ...
> > 
> > The email had literal escape sequences and git am preserved them, so git
> > show displayed red zeros and onces. [..]
> 
> Neat trick if it was intentionally!
> 
> > [...] That was quite scary, [...]
> 
> Scary if it was unintentional ;-)

Yeah, all our computers are bleeding :-) Well, I sent the first version
on the evening before Helloween...

<scary music playing, an old door is creaking...>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
