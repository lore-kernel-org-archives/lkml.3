Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaLIR1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:27:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaLIR1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:27:14 -0500
Date: Tue, 9 Dec 2014 18:27:09 +0100
From: Borislav Petkov <bp@suse.de>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, linux-doc@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] x86-64, doc: update to account for file shuffling
Message-ID: <20141209172709.GC4147@pd.tnic>
References: <1418079241-4362-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418079241-4362-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 02:54:01PM -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> While at it, also refer to the 32 bit entry file.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  Documentation/x86/entry_64.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
> index bc7226e..4796392 100644
> --- a/Documentation/x86/entry_64.txt
> +++ b/Documentation/x86/entry_64.txt
> @@ -7,9 +7,11 @@ http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
>  The x86 architecture has quite a few different ways to jump into
>  kernel code.  Most of these entry points are registered in
>  arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
> -and arch/x86/ia32/ia32entry.S.
> +for 64-bit, arch/x86/kernel/entry_32.S for 32-bit and finally
> +arch/x86/ia32/ia32entry.S which allows to run legacy 32-bit programs
> +under a 64-bit kernel.

Make that "... which implements the 32-bit compatibility syscall entry
points and thus provides for 32-bit processes to execute syscalls when
running on 64-bit kernels."

Or something like that. In any case, a bit more precise sounds better to
me.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
