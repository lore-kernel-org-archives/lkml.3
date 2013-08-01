Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3HAKQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:16:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56951 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HAKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <3402784.vRBPhVDbi3@vostro.rjw.lan>
References: <20130729102452.GA2682@zurbaran>
	<7008541.g5m1pJPVp1@vostro.rjw.lan>
	<20130729081141.00818596@lwn.net>
	<3402784.vRBPhVDbi3@vostro.rjw.lan>
Date: Thu, 1 Aug 2013 12:16:40 +0200
X-Google-Sender-Auth: 9OwuH7u1-Y_wcxm6ehbhy-zhSb4
Message-ID: <CAMuHMdVRPU5mE+ehx2dFLjqod4gGHiOHUy0ufP+rEs_ZtNkuDA@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development process
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>,
        Samuel Ortiz <sameo@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:09 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> A single SOB tag usually means that the committer himself is the author of
> the change set and I don't see why this should be regarded as a bad thing in
> principle.  Yes, it is technically possible for maintainers to "cheat", for
> example by making unreviewed changes and pushing them upstream with their
> own SOBs even without any linux-next testing, but they can do damage in some
> other ways too if they are irresponsible.
>
> We generally don't record information about what mailing lists the given patch
> was submitted and how much time the maintainer waited for comments before
> applying that patch.  I suppose we possibly could record it, but then I'm not
> sure how useful that will be in general.  It definitely would mean more work
> for maintainers and it's not like they don't have enough of that already.
> Moreover, perhaps we can simply expect maintainers not to abuse the process?
>
> I guess my point is that the fact that there are commits with one SOB tag only
> doesn't have to mean that we have a problem of any sort and it even doesn't
> have to indicate the existence of such a problem.
>
> Commits that have never been in linux-next are much more problematic in my
> opinion.

And we still have (too many of) them...

Once in a while, I do find suspicious commits that
  (a) weren't in -next,
  (b) weren't in my email archive (not unreasonable, as I'm not
subscribed to all
      Linux mailing lists ;-),
  (c) are not to be found by Google, which means they may not have been
      posted for public review at all (are there Linux mailing lists that do not
     have a web archive?).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
