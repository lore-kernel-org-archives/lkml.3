Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3KDUF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:05:28 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:44357 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3KDUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:05:27 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
Date: Mon, 4 Nov 2013 12:05:26 -0800
Message-ID: <CAOesGMiDwGpmPErH-=fFqoT=2Xg8pQ12V-QGVK+e8S-dyUHkYg@mail.gmail.com>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 3, 2013 at 4:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> The reason I mention it is because I've been mulling over something
> Dirk Hohndel said during LinuxCon EU and the kernel summit. He asked
> at the Q&A session whether we could do a release with just stability
> and bug-fixes, and I pooh-poohed it because I didn't see most of us
> having the attention span required for that
> (cough*cough*moronic*woodland creature*cough*cough).
>
> So I may be pessimistic, but I'd expect many developers would go
> "Let's hunt bugs.. Wait. Oooh, shiny" and go off doing some new
> feature after all instead. Or just take that release off.
>
> But I do wonder.. Maybe it would be possible, and I'm just unfairly
> projecting my own inner squirrel onto other kernel developers. If we
> have enough heads-up that people *know* that for one release (and
> companies/managers know that too) the only patches that get accepted
> are the kind that fix bugs, maybe people really would have sufficient
> attention span that it could work.
>
> And the reason I mention "4.0" is that it would be a lovely time to do
> that. Roughly a years heads-up that "ok, after 3.19 (or whatever),
> we're doing a release with *just* fixes, and then that becomes 4.0".
>
> Comments?

Ingo has some very good points. I think this might be worth doing in
some form or other, but if it's worth a full release cycle is less
certain to me:

Essentially we already do this for every release, where the last
couple of weeks are strictly bugfixes only. While it's not what you're
proposing, the end result sounds to me more like a "forced" extension
of the -rc cycle by several weeks to let more of those fixes come in.

If you're doing a 3.20/4.0 that is bugfixes only, then why release
3.19 at all? If the only difference between the two is said fixes,
we'd be better off just holding on until the latter is released. Which
again comes back to in practice extending the release by several more
weeks of late -rcs.

The only benefit I can think of to make a 3.19 release is to pick up
more users, if some of them avoid -rcs but do use full releases
shortly after they are tagged. I don't know how common that is though.


-Olof
