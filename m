Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3KXJPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:15:41 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38479 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3KXJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:15:35 -0500
MIME-Version: 1.0
In-Reply-To: <B586EBD8-8CB6-4E65-BC01-7B038A1885D3@dubeyko.com>
References: <1384461563-4487-1-git-send-email-geert@linux-m68k.org>
	<20131114210617.4e68b086@alan.etchedpixels.co.uk>
	<B586EBD8-8CB6-4E65-BC01-7B038A1885D3@dubeyko.com>
Date: Sun, 24 Nov 2013 10:15:34 +0100
X-Google-Sender-Auth: jOozPH-dCghuEcIOpiBpOBOhpOo
Message-ID: <CAMuHMdV6hBgin-sXLPGCLMqvhEZ5g1k5pc13D2dw6G1fpZYusg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add an entry for the Macintosh HFSPlus Filesystem
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 11:02 AM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
> On Nov 15, 2013, at 12:06 AM, One Thousand Gnomes wrote:
>> On Thu, 14 Nov 2013 21:39:23 +0100
>> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>>> To make scripts/get_maintainer.pl output something sensible.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> ---
>>> I guess it's orphaned, just like HFS?
>>
>> Looking at bugzilla - yes
>
> What do you means by orphaned? If you means absence of implementation or bug fix
> then I disagree completely. Because I am making some implementation activity for

Thanks, good to hear that!

> HFS+. If you are talking about absence of using HFS+ by ordinary users then I disagree again.
> Because, as far as I can see, there are many Apple devices that it has HFS+ file system
> then it makes sense to have actual support for HFS+ file system under Linux.

>From the top of MAINTAINERS:

        S: Status, one of the following:
           Supported:   Someone is actually paid to look after this.
           Maintained:  Someone actually looks after it.
           Odd Fixes:   It has a maintainer but they don't have time to do
                        much other than throw the odd patch in. See below..
           Orphan:      No current maintainer [but maybe you could take the
                        role as you write your new code].
           Obsolete:    Old code. Something tagged obsolete generally means
                        it has been replaced by a better system and you
                        should be using that.

Hence Orphan doesn't mean there are no active users, only that there's no active
maintainter listed.

If you want to become the maintainer for hfs+, I'm happy to send a v2
of the patch,
adding you as the maintainer, with status Supported/Maintained/Odd Fixes.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
