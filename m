Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935793Ab3DJTkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:40:09 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:32818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935229Ab3DJTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:40:05 -0400
Message-ID: <1365622791.4235.38.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 06/18] compat: backport ASYNC_DOMAIN_EXCLUSIVE()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Apr 2013 21:39:51 +0200
In-Reply-To: <CAB=NE6W8wZbwGiCCq2n2LObNreWhxd-uFU7CrX5yJw2Uik9hAg@mail.gmail.com> (sfid-20130410_213320_489401_CDFE35C3)
References: <1365593728-5720-1-git-send-email-mcgrof@do-not-panic.com>
	 <1365593728-5720-7-git-send-email-mcgrof@do-not-panic.com>
	 <1365600139.4235.4.camel@jlt4.sipsolutions.net>
	 <CAB=NE6UpP-X1NCTNRnoSdv_bk3ioZdg5bO1zz0U0dqeWVxZdLw@mail.gmail.com>
	 <1365614413.4235.29.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VAfAvjRs0uZ=jpMjfP5Dz-zEHu3N7t8AUAofZAggrEEQ@mail.gmail.com>
	 <1365618018.4235.35.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VKT11k95Szi4NmigKCgMJ1XJoU3+rACbJpnWwUpCC1EA@mail.gmail.com>
	 <1365622074.4235.37.camel@jlt4.sipsolutions.net>
	 <CAB=NE6W8wZbwGiCCq2n2LObNreWhxd-uFU7CrX5yJw2Uik9hAg@mail.gmail.com>
	 (sfid-20130410_213320_489401_CDFE35C3)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 12:32 -0700, Luis R. Rodriguez wrote:

> >> Oh I agree don't get me wrong, however porting kernel/async.c seems
> >> like a rather separate effort worth considering. As-is though I have
> >> not seen any negative impact though to keep older subsystems from
> >> compiling, ie its a no-op for older kernels as I see it.
> >
> > I guess that's what I don't understand -- I don't see usages of
> > ASYNC_DOMAIN_EXCLUSIVE in any header files, and in e.g. regulator/core.c
> > you'd also need the functions async_schedule_domain() etc. So where does
> > this help even compiling?
> 
> You know what, sorry this was left over from when I tried to backport
> the regulatory to the core of compat, and since I decided to not even
> go there given that it relies on init sections on the vmlinux we can
> safely discard this patch (although what I said still hold, just not
> needed).

Ok. Yeah after looking at the users I actually do agree this won't
really hurt, but it seemed it doesn't help anything at all hence my
confusion... :)

johannes

