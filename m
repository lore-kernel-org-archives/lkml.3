Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3A1WGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:06:15 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33847 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3A1WGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:06:12 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130128192807.GF22465@mtj.dyndns.org>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
	<CA+icZUX=XdAJjWwx8P_y31JGW3GC+tdWuFhv2Ym-0OELGWGbDQ@mail.gmail.com>
	<CA+icZUX31SB3+NU8uXA9LH5KOHxgeHKZLcqWNhzUVhx5onk6qA@mail.gmail.com>
	<18624541.r6CtJttOWZ@vostro.rjw.lan>
	<CA+icZUX+o6kB9wXwpuJ8U49j+qHdx=DRq7p+_U1g+1fwGb-S6w@mail.gmail.com>
	<20130128192807.GF22465@mtj.dyndns.org>
Date: Mon, 28 Jan 2013 23:06:11 +0100
Message-ID: <CA+icZUUHFFB6j-igX-Ec+6ZT2yvGakRd+HNVru1VUAxPXby_Lg@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 25 (BROKEN suspend)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, guys.
>
> On Sun, Jan 27, 2013 at 02:01:50PM +0100, Sedat Dilek wrote:
>> OK, that bisecting ruined a bit my weekend and showed me again you
>> cannot really bisect Linux-Next.
>> Sometimes, it is better not to trust the tools blindly and do a
>> bisect-on-suspicion.
>> Anyway... cultprit found... patch found... applied... all GOOD now.
>> ( If I had waited for next Monday's next-20130127 I would not have
>> seen what caused the trouble. ).
>
> Yeah, my usual test setup didn't have async tasks w/o domain so I
> failed to notice the breakage.  Sorry about the trouble guys and lots
> of thanks to Sedat for the firefighting over the weekend.  :)
>

[ CC James ]

Hi Tejun,

I don't see that git-bisect session as a time of waste, but two hints:

1. People should sent their patches concerning especially Linux-Next
fixes not only to LKML but also to <linux-next@vger.kernel.org> (if
this is not known, pointing to James).

2. These patches for Linux-Next should contain a "-next" in their
subject-line (use 'git format-patch --subject-prefix="PATCH -next"
...').

Of course, I should have checked the MLs... but for me it was not
clear what was the root cause (which subsystem to blame)... I had only
some suspicions.

Anyway, noone gave me any pointer on how to log bastard logs before my
system got frozen (2nd machine not available).
I know that is tricky!

For a better world...

Regards,
- Sedat -


> --
> tejun
