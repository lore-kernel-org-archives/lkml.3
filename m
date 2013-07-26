Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab3GZLWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:22:55 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:52805 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3GZLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:22:51 -0400
Message-ID: <1374837764.18839.3.camel@ThinkPad-X230.localdomain>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Fri, 26 Jul 2013 15:22:44 +0400
In-Reply-To: <9711528.yIoJy2i1iX@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <2218913.HKGjJcYT1G@vostro.rjw.lan>
	 <CAAG0J98i-XaO_3sPWsnyEGDX77T=WiNf1K=YMhe5DvkwKotorw@mail.gmail.com>
	 <9711528.yIoJy2i1iX@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 21:47 +0200, Rafael J. Wysocki wrote:
> On Thursday, July 25, 2013 08:14:08 PM James Hogan wrote:
> > On 25 July 2013 14:00, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
> > >> On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > >> > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >> > >
> > >> > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
> > >> >
> > >> > Yes, but let's wait a while. Not because I think we'll fix the problem
> > >> > (hey, miracles might happen), but because I think it would be useful
> > >> > to couple the reverts with information about the particular machines
> > >> > that broke (and the people who reported it). So that when we
> > >> > inevitably try again, we can perhaps get some testing effort with
> > >> > those machines/people.
> > >> >
> > >> > It doesn't seem to be a show-stopped for a large number of people, so
> > >> > there's no huge hurry. I'd suggest doing the revert just in time for
> > >> > rc3, but waiting until then to gather info about people who see
> > >> > breakage.
> > >> >
> > >> > Sound like a plan?
> > >>
> > >> Yes, it does.
> > >
> > > OK, time to revert I guess.
> > >
> > > James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
> > > fixes the backlight for you.
> > 
> > Works for me
> 
> Great!
> 
> James, Kamal, Jörg, thanks for confirmations.  I'll tentatively put the revert
> into linux-next in a while.
> 
> Other people who experienced problems with backlight in 3.11-rc2, please let me
> know whether or not the revert works for you too if you can.
> 
> Rafael
> 
> 

Rafael, feel free to CC me in messages with backlight ;) I want to test
its)
-- 
Igor Gnatenko
Fedora release 19 (Schrödinger’s Cat)
Linux 3.9.9-302.fc19.x86_64

