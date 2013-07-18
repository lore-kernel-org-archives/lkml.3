Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab3GRHGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:06:01 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38406 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab3GRHF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:05:59 -0400
Date: Thu, 18 Jul 2013 09:05:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86: Make sure IDT is page aligned
Message-ID: <20130718070555.GC17622@gmail.com>
References: <20130716183441.GA14232@www.outflux.net>
 <tip-4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7@git.kernel.org>
 <CAE9FiQV86WdgN3+3FOSSTUvNJ6TgH4zbYkWOS7EPPHwO2Rf2TQ@mail.gmail.com>
 <51E6F73F.3000202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E6F73F.3000202@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 07/17/2013 11:57 AM, Yinghai Lu wrote:
> > 
> > Hi, Peter,
> > 
> > Any reason for why following changelog get dropped?
> > 
> > ---
> > v5:
> >  - add comments to all IDTs about alignment reasoning, suggested by Linus
> > v4:
> >  - rework using __page_aligned_bss, suggested by Yinghai LU
> >  - move all the other IDT variables as well, suggested by HPA
> > v3:
> >  - merge 32-bit and 64-bit idt_table definition
> > v2:
> >  - 32-bit was already aligned
> > ---
> > 
> > That at least would help us to check if you apply the right version.
> > 
> 
> Procedurally, the changelogs don't belong in commit messages.  I tend to
> leave them in if they are particularly illustrative or if the commit
> message only makes sense with the additional context, but neither of
> those is really ideal.
> 
> Technically, because of the --- line which indicates the end of the
> commit message.

Furthermote, the -tip notification email will generally email-thread on 
lkml to the patch submission that was applied.

That is a more robust indication of which submission was applied than any 
changelog detail.

Thanks,

	Ingo
