Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3HEEUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:20:32 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58772 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3HEEUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:20:31 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
Date: Sun, 4 Aug 2013 23:20:27 -0500
Message-ID: <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 4:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> It's that time of the week again..
>
>  "You apply 339 patches, what do you get
>   Another week older and deeper in debt
>   Saint Peter don't you call me 'cause I can't go
>   I owe my soul to the company store"
>
> I had hoped things would start calming down, but rc4 is pretty much
> exactly the same size as rc3 was. That said, the patches seem a bit
> more spread out, and less interesting - which is a good thing. Boring
> is good. Let's keep it that way, and try to make for fewer patches for
> -rc5, ok? Because we are past half-way now, and I really want to see
> just fixes.
>
> We've got some arch updates (arm, parisc), but most of this is drivers
> (mostly networking, usb and some drm updates). There's also some core
> networking changes. And the printk code movement looks big if you
> don't do git renames (ie like the patches I upload).

I found a regression while running all v3.11-rcX kernels; Starcract II
through wine crashes. The culprit is fab840f (ptrace: PTRACE_DETACH
should do flush_ptrace_hw_breakpoint(child)), I revert that commit and
there's no crash.

-- 
Felipe Contreras
