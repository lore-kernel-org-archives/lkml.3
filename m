Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab3GZMa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:30:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41550 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab3GZMay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:30:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>,
        Steven Newbury <steve@snewbury.org.uk>,
        Joerg Platte <jplatte@naasa.net>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
Date: Fri, 26 Jul 2013 14:40:58 +0200
Message-ID: <1854576.vakuIzNrby@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1991250.FX2pHCjA6v@merkaba>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <2218913.HKGjJcYT1G@vostro.rjw.lan> <1991250.FX2pHCjA6v@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 02:09:08 PM Martin Steigerwald wrote:
> Am Donnerstag, 25. Juli 2013, 15:00:26 schrieb Rafael J. Wysocki:
> > On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
> > > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > Linus, do you want me to send a pull request reverting 8c5bd7a and
> > > > > efaa14c?
> > > > 
> > > > Yes, but let's wait a while. Not because I think we'll fix the problem
> > > > (hey, miracles might happen), but because I think it would be useful
> > > > to couple the reverts with information about the particular machines
> > > > that broke (and the people who reported it). So that when we
> > > > inevitably try again, we can perhaps get some testing effort with
> > > > those machines/people.
> > > > 
> > > > It doesn't seem to be a show-stopped for a large number of people, so
> > > > there's no huge hurry. I'd suggest doing the revert just in time for
> > > > rc3, but waiting until then to gather info about people who see
> > > > breakage.
> > > > 
> > > > Sound like a plan?
> > > 
> > > Yes, it does.
> > 
> > OK, time to revert I guess.
> > 
> > James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended
> > patch fixes the backlight for you.
> 
> Rafael, do you still need more testing urgently? Otherwise I´d wait till its 
> in some next 3.11 rc and test then.

Well, it seems to work for everybody else (Steven, Joerg, thanks for your
reports!), so I don't think you need to test it urgently.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
