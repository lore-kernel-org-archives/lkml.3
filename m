Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3GRHsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:48:19 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42051 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3GRHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:48:18 -0400
Date: Thu, 18 Jul 2013 09:48:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        kerolasa@iki.fi, Borislav Petkov <bp@alien8.de>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/boot: Add lz4 compressed file to .gitignore
 file
Message-ID: <20130718074813.GA23149@gmail.com>
References: <tip-8192f5bccf26968a1d78ef71890f7a27f824119f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-8192f5bccf26968a1d78ef71890f7a27f824119f@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Sami Kerola <tipbot@zytor.com> wrote:

> Commit-ID:  8192f5bccf26968a1d78ef71890f7a27f824119f
> Gitweb:     http://git.kernel.org/tip/8192f5bccf26968a1d78ef71890f7a27f824119f
> Author:     Sami Kerola <kerolasa@iki.fi>
> AuthorDate: Wed, 17 Jul 2013 17:30:28 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 18 Jul 2013 09:03:33 +0200
> 
> x86/boot: Add lz4 compressed file to .gitignore file
> 
> Signed-off-by: Sami Kerola <kerolasa@iki.fi>
> Link: http://lkml.kernel.org/n/tip-wjc5bf2MtnlqihpoMvzutwby@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/boot/compressed/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/boot/compressed/.gitignore b/arch/x86/boot/compressed/.gitignore
> index 4a46fab..a30c02e 100644
> --- a/arch/x86/boot/compressed/.gitignore
> +++ b/arch/x86/boot/compressed/.gitignore
> @@ -1,5 +1,6 @@
>  relocs
>  vmlinux.bin.all
> +vmlinux.bin.lz4
>  vmlinux.relocs
>  vmlinux.lds
>  mkpiggy

I removed this patch again, Boris pointed me to an overlapping, more 
complete patch posted at:

  http://marc.info/?l=linux-kbuild&m=137353601112047&w=2

and the top level .gitignore is where we exclude compressed files, not 
arch/x86/boot/compressed/.gitignore.

Thanks,

	Ingo
