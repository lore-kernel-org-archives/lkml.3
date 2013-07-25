Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3GYOqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:46:32 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:45225 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3GYOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:46:29 -0400
Date: Thu, 25 Jul 2013 16:46:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Kamal Mostafa <kamal@canonical.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Hogan <james@albanarts.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
Message-ID: <20130725144625.GO5939@phenom.ffwll.local>
Mail-Followup-To: Kamal Mostafa <kamal@canonical.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	James Hogan <james@albanarts.com>, Aaron Lu <aaron.lu@intel.com>,
	Kalle Valo <kvalo@adurom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Newbury <steve@snewbury.org.uk>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	=?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Jani Nikula <jani.nikula@linux.intel.com>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
 <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
 <9012759.Alzqtdvh5b@vostro.rjw.lan>
 <2218913.HKGjJcYT1G@vostro.rjw.lan>
 <1374763397.5374.30.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374763397.5374.30.camel@fourier>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 07:43:17AM -0700, Kamal Mostafa wrote:
> On Thu, 2013-07-25 at 15:00 +0200, Rafael J. Wysocki wrote:
> > On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
> > > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > >
> > > > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
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
> > James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
> > fixes the backlight for you.
> 
> Yes, this revert patch does re-enable backlight control for the affected
> Dell XPS13 models.

Are these the same models that neeed the special quirk to not write
PCH_PWM_ENABLE? Or do they need both?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
