Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab3L1VZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 16:25:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45622 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3L1VZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 16:25:26 -0500
Date: Sat, 28 Dec 2013 22:25:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>, Joe Xue <lgxue@hotmail.com>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: how to represent sequence of brightnesses in /sys (was Re:
 [PATCH] Add the LED burst trigger)
Message-ID: <20131228212523.GA8733@amd.pavel.ucw.cz>
References: <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
 <20131226142607.GA15225@amd.pavel.ucw.cz>
 <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
 <20131227095705.GC17143@amd.pavel.ucw.cz>
 <BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>
 <20131228101622.GA13564@amd.pavel.ucw.cz>
 <CAMuHMdVz7FWgYZRVHy6pK+g_2QKxTW00N8jmjWHe05m5CJvPOw@mail.gmail.com>
 <20131228192935.GA28119@amd.pavel.ucw.cz>
 <CAMuHMdXDJ6uhe6srV-+0a8=cpBUgP+VakG+_wyLwAuiQSRVhqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXDJ6uhe6srV-+0a8=cpBUgP+VakG+_wyLwAuiQSRVhqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Sysfs is meant to be human-readable/writable, so please use plain ASCII
> >> numbers in strings instead.
> >
> > Actually, sysfs is meant to be one value per file, and it is
> 
> Ideally, yes.
> 
> > understood that data that are "natively blob" are just passed as
> > blob. (I believe this qualifies).
> 
> But it doesn't buy us much here, does it? It will make e.g. shell scripts
> needlessly complicated.

echo -ne '\012' is not that bad, and parsing array of integers from
kernel will be an ugly piece of code.

Anyway I don't care much, either byte array or ascii array of integers
is fine with me. (But I was under impression that after /proc
experiences, the latter is forbidden; I might be wrong.
/data/l/linux-good/Documentation/sysfs-rules.txt should be updated).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
