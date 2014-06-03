Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaFCBaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:30:23 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:42559 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaFCBaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140603012211.GE19855@htj.dyndns.org>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
	<538D2261.70406@huawei.com>
	<20140603012211.GE19855@htj.dyndns.org>
Date: Mon, 2 Jun 2014 18:30:20 -0700
X-Google-Sender-Auth: KJ-ZEPiAU6Z-bHbbLsu48B2QnUg
Message-ID: <CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 6:22 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Linus, can you please cherry-pick the commit?

I'd much rather see it go through the proper channels than go ahead
and cherry-pick from some branch that hasn't even been sent to me yet.
The whole "you have to send things to me for me to take them" policy
is not new, I don't want to start taking stuff that the
authors/maintainers haven't actively sent my way.

That said, I suspect that Greg didn't expect this to actually matter
(the commit message certainly doesn't make it sound like anything that
people would notice), so the reason it is in -next is likely that
nobody thought it was a regression.

Of course, Greg could just send it to me for my next branch (since the
merge window for 3.16 is already open) and tell me that it's also
stable material for 3.15. At _that_ point I'll happily cherry-pick it
intpo master...

                Linus
