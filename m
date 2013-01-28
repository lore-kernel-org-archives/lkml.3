Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3A1WSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:18:54 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57948 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3A1WSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:18:52 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130128220844.GO22465@mtj.dyndns.org>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
	<CA+icZUX=XdAJjWwx8P_y31JGW3GC+tdWuFhv2Ym-0OELGWGbDQ@mail.gmail.com>
	<CA+icZUX31SB3+NU8uXA9LH5KOHxgeHKZLcqWNhzUVhx5onk6qA@mail.gmail.com>
	<18624541.r6CtJttOWZ@vostro.rjw.lan>
	<CA+icZUX+o6kB9wXwpuJ8U49j+qHdx=DRq7p+_U1g+1fwGb-S6w@mail.gmail.com>
	<20130128192807.GF22465@mtj.dyndns.org>
	<CA+icZUUHFFB6j-igX-Ec+6ZT2yvGakRd+HNVru1VUAxPXby_Lg@mail.gmail.com>
	<20130128220844.GO22465@mtj.dyndns.org>
Date: Mon, 28 Jan 2013 23:18:51 +0100
Message-ID: <CA+icZUU-Nd=bjivSZ62iFm3qWSLy-_SyfMcA+xNB9-3oxOwYBA@mail.gmail.com>
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

On Mon, Jan 28, 2013 at 11:08 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Sedat.
>
> On Mon, Jan 28, 2013 at 11:06:11PM +0100, Sedat Dilek wrote:
>> 1. People should sent their patches concerning especially Linux-Next
>> fixes not only to LKML but also to <linux-next@vger.kernel.org> (if
>> this is not known, pointing to James).
>>
>> 2. These patches for Linux-Next should contain a "-next" in their
>> subject-line (use 'git format-patch --subject-prefix="PATCH -next"
>> ...').
>>
>> Of course, I should have checked the MLs... but for me it was not
>> clear what was the root cause (which subsystem to blame)... I had only
>> some suspicions.
>
> Yeah, there was no way for you guys to easily discover that the
> problem has already been identified and fix pending.  I'll definitely
> try to cc linux-next cc'd on patches which fix problems in -next.
>
> Thanks a lot!
>

Hi Tejun,

BTW, I am reading MLs mostly offline!
That means I cannot grep for search-patterns I like (here: LKML).
Offline-reading also means, you get replies a lot of later.

NO, I am not planning to flood my INBOX with postings from LKML :-).

I highly suggest to send -next patches also to LKML.
Patchwork-service [1] makes it easy to get them in mbox-format for
easy application.

FYI: I am subscribed to linux-next ML and some other "smaller" linux-* MLs.

I dunno why Linux-Next hasn't join patchwork-service.
Stephen?

Also think of multiple postings of patches for the same issue :-).
...and lame and/or disappeared maintainers.

For a more better world...

- Sedat -

[1] marc.info/?l=linux-kernel
[2] http://marc.info/?l=linux-next
[3] https://patchwork.kernel.org/project/LKML/list/

> --
> tejun
