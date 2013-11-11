Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3KKUnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:43:43 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63324 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3KKUne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:43:34 -0500
Date: Mon, 11 Nov 2013 21:43:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH -v1.1] Kbuild: Ignore GREP_OPTIONS env variable
Message-ID: <20131111204330.GC18886@gmail.com>
References: <20131030160635.GE13290@pd.tnic>
 <527AB7D1.9080307@suse.cz>
 <20131111142743.GE28219@pd.tnic>
 <20131111170041.GA18517@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131111170041.GA18517@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Marek <mmarek@suse.cz> wrote:

> On Mon, Nov 11, 2013 at 03:27:43PM +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > Subject: [PATCH] Kbuild: Ignore GREP_OPTIONS env variable
> > 
> > When building the kernel in a shell which defines GREP_OPTIONS so that
> > grep behavior is modified, we can break the generation of the syscalls
> > table like so:
> > 
> > __SYSCALL_COMMON([01;31m[K0[m[K, sys_read, sys_read)
> > __SYSCALL_COMMON([01;31m[K1[m[K, sys_write, sys_write)
> > __SYSCALL_COMMON([01;31m[K1[m[K0, sys_mprotect, sys_mprotect) ...
> 
> The email had literal escape sequences and git am preserved them, so git
> show displayed red zeros and onces. [..]

Neat trick if it was intentionally!

> [...] That was quite scary, [...]

Scary if it was unintentional ;-)

Thanks,

	Ingo
