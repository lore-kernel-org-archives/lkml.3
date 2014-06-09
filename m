Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaFITJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:09:09 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:62446 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaFITJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140602214019.GA2134@redhat.com>
References: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
	<20140602214019.GA2134@redhat.com>
Date: Mon, 9 Jun 2014 21:09:04 +0200
X-Google-Sender-Auth: lgNyPiiHGIURrc6K0Ela0T788YI
Message-ID: <CAMuHMdUikt_rW+rx+2NfpnAKV_2J_DP__U6nV9os--ZQ2HdQyg@mail.gmail.com>
Subject: Re: Linux 3.15-rc8 ... and merge window for 3.16
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 11:40 PM, Dave Jones <davej@redhat.com> wrote:
> On Sun, Jun 01, 2014 at 07:37:20PM -0700, Linus Torvalds wrote:
>  > So let's try to see how well that works - the last weeks of the
>  > release tends to be me just waiting around to make sure nothing bad is
>  > happening, so doing this kind of overlapping development *should* work
>  > fine. Maybe it works so well that we'll end up doing it in the future
>  > even if there *isn't* some kind of scheduling conflict that makes me
>  > want to start the merge window before I'm 100% comfortable doing the
>  > release for the previous version.
>
> one side-effect of this is that the git-commits-head list is now posting
> the commits you're queueing in your next branch but no way afaict to
> distinguish them from changes going into 3.15
>
> Can whoever maintains that hook add an X-branch header or something to make
> filtering them easier ?

Not to mention what happened when "next" got merged into "master": we
received another copy of all commits. I had a backlog of only 4000 commits
before the weekend, but after the pentecost holidays, this increased to 12000,
incl. 5000 duplicates or so.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
