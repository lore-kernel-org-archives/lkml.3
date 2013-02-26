Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab3BZVhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:37:43 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:56267 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3BZVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121208162257.GA27005@odin.tremily.us>
References: <20121124232202.GA29962@odin.tremily.us> <20121124142515.GA26479@odin.tremily.us>
 <20121121001043.7e1a68df@pyramind.ukuu.org.uk> <20121208162257.GA27005@odin.tremily.us>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 26 Feb 2013 13:37:20 -0800
X-Google-Sender-Auth: HxN51BlHYf1e0HgBlZnaPYci3ZU
Message-ID: <CAB=NE6U6+NJPwS=ccHArqtuxcPuZwbWat6YnA81NKHQ2a0CW6Q@mail.gmail.com>
Subject: Re: Streamlining Developer's Certificate of Origin, Signed-off-by tag
To: "W. Trevor King" <wking@tremily.us>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Jim Meyering <meyering@redhat.com>, Junio C Hamano <gitster@pobox.com>,
        Miklos Vajna <mszeredi@suse.cz>,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Zac Storer <zac.3.14159@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 8:22 AM, W. Trevor King <wking@tremily.us> wrote:
> On Wed, Nov 21, 2012 at 12:10:43AM +0000, Alan Cox wrote:
>> > Not just a separate document but project / github / whatever given
>> > that other projects are referring to it now, and we stand to gain more
>> > in the community by streamlining it more and making it ubiquitous.
>>
>> Cutting and pasting it somewhere works (subject to whatever licensing
>> it may have itself), as does having a list and a location for a copy, but
>> you still want it in the tree proper.
>
> For easy inclusion (preserving history), I've pulled out commits for
> the DCO and related Signed-off-by documentation from Linux and Git
> into a new repository [1].
>
> On Sat, Nov 24, 2012 at 09:25:15AM -0500, W. Trevor King wrote:
>> So.  What license is the DCO distributed under and who holds
>> copyright?
>
> The Git project did some similar copying of the DCO into a new project
> [2] and is (like the kernel) distributed under the GPLv2 exact.  To be
> consistent with this, I've also released the new signed-off-by
> repository under the GPLv2 exact.  If you're using a GPLv2 exact
> project, you can merge the `signed-off-by` branch into your project
> directly.
>
> Because many projects that are not GPLv2 may still want to use the
> DCO/s-o-b approach, I've included an example CONTRIBUTING file (and
> CONTRIBUTING.md for GitHub) that are licensed under the very
> permissive Creative Commons CC0 1.0 Universal.  Merge the
> `contributing` or `contributing-github` branch into your project and
> edit as you see fit.  For an example, see the GPLv{2,3} rss2email [3].

This is awesome, thanks! I've started to use your work in my projects.
I'll Cc you on an e-mail post about this and copyleft-next section 7.

  Luis
