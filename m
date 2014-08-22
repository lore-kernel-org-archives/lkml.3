Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaHVXbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:31:07 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63390 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaHVXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <1408749762.17241.50.camel@joe-AO725>
References: <20140821162050.GA1323@www.outflux.net>
	<1408641520.23250.71.camel@joe-AO725>
	<CAGXu5jJmp4-sposMxjTobEj0xzueQY54OzvdDQg-GC-HhJuBwQ@mail.gmail.com>
	<1408666251.22832.33.camel@joe-AO725>
	<1408747041.17241.39.camel@joe-AO725>
	<94D0CD8314A33A4D9D801C0FE68B402958C1CAFD@G9W0745.americas.hpqcorp.net>
	<1408749762.17241.50.camel@joe-AO725>
Date: Fri, 22 Aug 2014 16:31:03 -0700
X-Google-Sender-Auth: KABeAxjOpHUQxKzOl2a6aeqJppc
Message-ID: <CAGXu5jJi77abkA=1Nzxf3wvFuOP_iDuqnnyikKJWj6QJWmoj8Q@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: look for common misspellings
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Masanari Iida <standby24x7@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 4:22 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2014-08-22 at 23:00 +0000, Elliott, Robert (Server Storage)
> wrote:
>> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> > owner@vger.kernel.org] On Behalf Of Joe Perches
>> ...
>> > +chang||change
>>
>> Although there are at least 2 misuses in the current kernel,
>> that's also a fairly common name.
>
> True.  Thanks.
>
> That one should likely be removed.
> There are dozens of Chang name uses in the kernel.

Right, I removed a bunch similar things like this.

> I'm not attached at all to any of these btw.
>
> Any others you think should not be used or
> should be added?
>
> One I thought kind of iffy was
>
>         contant||contact
>
> Maybe that should be content instead.

Or "constant". I'll go through the list and see if anything stands out.

> Another thing the script might do is to check
> if the $typo match is all upper case and then
> substitute an all upper case $typo_fix.

That might be a good idea.

> It's also kind of noisy when run using -f,
> so maybe this test should be --strict check with
> files and a warning with patches.

Sure, seems reasonable. I'll get a v2 spun up.

-Kees

-- 
Kees Cook
Chrome OS Security
