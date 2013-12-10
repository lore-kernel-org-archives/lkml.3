Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab3LJFjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:39:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:35024 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3LJFjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:39:41 -0500
Message-ID: <1386653965.32037.61.camel@pasglop>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 16:39:25 +1100
In-Reply-To: <CA+55aFz_VXtkX0vH+T2kGpzA90Zqys=_quJFq3fGT68YTCnBtw@mail.gmail.com>
References: <1386640667.32037.53.camel@pasglop>
	 <CA+55aFz_VXtkX0vH+T2kGpzA90Zqys=_quJFq3fGT68YTCnBtw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 19:58 -0800, Linus Torvalds wrote:
> On Mon, Dec 9, 2013 at 5:57 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > Here are a handful of powerpc fixes for 3.13.
> 
> Grr.
> 
> I've pulled it, but looking at that history, it's just pure and utter
> f*cking garbage.
> 
> It was rebased *minutes* before sending it, as far as I can tell. Why?

It was *created* shortly before sending it:

Basically I put that thing together as a patchwork bundle which I grew
over this week.

Today I just applied them to my git, ran my build testers, booted a
machine to dbl check and sent. I tend to not let things linger long in
git when it's just fixes like that.

> And it has a pointless merge that you must have created with "--no-ff"
> for no apparent good reason.

Oh that's my fault. I thought you preferred that way to keep track of
cases where I pull from somebody since then the patch don't have my
s-o-b... my bad for misunderstanding that part of the process.

> WTF? What the hell happened here, and why? As mentioned, it's in my
> tree, but I was *this* close to just unpulling and saying "fuck that"
> when I started looking at it.

Heh sorry.

Cheers,
Ben.

> 
>               Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


