Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3GVM6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:58:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60752 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3GVM6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:58:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Date: Mon, 22 Jul 2013 15:08:13 +0200
Message-ID: <2494093.OzngazxDQW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51EC4D77.2010502@mni.thm.de>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <51EC4D77.2010502@mni.thm.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 21, 2013 11:07:03 PM Tobias Klausmann wrote:
> On 21.07.2013 21:53, Linus Torvalds wrote:
> > So it's been another week, and -rc2 is out there.
> ...
> >
> >   (b) we had a late change to how ACPI backlight handling is done on
> > certain machines, and while this kind of thing really shouldn't be
> > done outside the merge window, I ended up pulling it anyway. But I'd
> > *really* like to have people test this thing particularly on laptops
> > with intel-based graphics. It should only matter (and hopefully
> > improve things) for the newer ones with BIOSes designed for Windows 8,
> > but hey, the more testing, the better. Backlight handling has been
> > painful before, so I'm mentioning this explicitly.
> >
> 
> This pach finally fixes my backlight control!

Yes, it fixes that for a number of people, which is the reason why I send
the pull request in the first place, but it also turns out to break things
for some people and therefore it'll have to be reverted.

We're still going to work on that, though.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
