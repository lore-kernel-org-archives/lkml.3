Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3HTXkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:40:52 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:35578 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3HTXku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:40:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130820224032.GA20491@kroah.com>
References: <20130820224032.GA20491@kroah.com>
Date: Tue, 20 Aug 2013 19:40:49 -0400
X-Google-Sender-Auth: Grez8mgx9pPDkb1phjJ74dx5uyQ
Message-ID: <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
Subject: Re: Proposed stable release changes
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 6:40 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Hi all,
>
> Given that I had to just revert a patch in the recent stable releases
> that didn't get enough time to "bake" in Linus's tree (or in -next), I
> figured it was worth discussing some possible changes with how "fast" I
> pick up patches for stable releases.
>
> So, how about this proposal:
>
> - I will wait for a -rc to come out with the patch in it before putting
>   it into a stable release, unless:
>         - the maintainer ACKs it, or sends it directly (like DaveM does
>           for networking patches)
>         - I have seen enough discussion about a patch to show that it
>           really does fix something / is good / doesn't cause problems.
>         - obviously safe, i.e. "add a device id" type thing.
>
> Given that we have -rc releases every week, except for the initial -rc1
> release, I don't think this will really cause any major delays.
>
> Also, now that we are about to head into my busy "travel season", odds
> are, I'll be at least a week behind anyway, so this would probably start
> happening without an "official" change.  It's been a boring summer, I've
> been able to keep up with the stable stuff really easily, causing
> problems like this :)
>
> Objections?  Comments?

I like this overall.  The only thing I might change is "wait for -rc2"
for patches tagged with CC: stable that go in during the merge window.
 It seems those are the ones that tend to bite us.

Overall though, I think waiting for the next -rc is a good balance.

josh
