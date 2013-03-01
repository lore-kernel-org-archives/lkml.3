Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3CASDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:03:51 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:51912 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CASDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:03:50 -0500
MIME-Version: 1.0
In-Reply-To: <5130DD94.2060408@imgtec.com>
References: <5130DD94.2060408@imgtec.com>
Date: Fri, 1 Mar 2013 10:03:49 -0800
X-Google-Sender-Auth: U4Vyu7smiFXovkn4HMy0w7u55hk
Message-ID: <CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 8:55 AM, James Hogan <james.hogan@imgtec.com> wrote:
>
> Please pull the following changes in addition to my previous arch/metag
> pull request. See the tag (below) for details. The shortlog is a bit
> inflated unfortunately as it includes the previous pull request too.
> I've marked where the new changes begin though.

Yeah, that would be a no. I finally got to look at the new
architectures and be ready to pull them, and you just made sure I
won't pull this.

This is exactly the kind of crap I don't want to see in *any* pull
requests, much less for a new sub-area.

>       metag: copy devicetree to non-init memory
>       metag: prom.h: remove declaration of metag_dt_memblock_reserve()
>       metag: Provide dma_get_sgtable()
>       Merge commit 'burying unused conditionals'
>       metag: remove GENERIC_SIGALTSTACK
>       Merge commit 'irq_work: Remove CONFIG_HAVE_IRQ_WORK'
>       metag: remove select CONFIG_HAVE_IRQ_WORK
>       Merge commit 'make CONFIG_EXPERIMENTAL invisible and default'
>       metag: remove CONFIG_EXPERIMENTAL from defconfigs
>       Merge commit 'default SET_PERSONALITY() in linux/elf.h'
>       metag: remove SET_PERSONALITY()

Why the f*ck are you doing back-merges? There is no excuse for even a
single one. And here you have just about one back-merge per commit.

No, no no.

At least you have explanations, but you already had one from before,
now you added four more. Don't do it. Let me know about fixups, or
just wait for me to pull, but doing back-merges for trivial issues
just makes things worse, and makes it much harder to see what the heck
is up.

             Linus
