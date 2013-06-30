Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3F3QuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:50:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51035 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3Qt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:49:58 -0400
Date: Sun, 30 Jun 2013 18:49:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mark Lord <kernel@start.ca>, Ondrej Zary <linux@rainbow-software.org>,
        Mark Lord <mlord@pobox.com>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130630164956.GA26305@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
 <20130623215100.GA7414@amd.pavel.ucw.cz>
 <201306240914.29502.linux@rainbow-software.org>
 <20130629184716.GA9330@khazad-dum.debian.net>
 <51CF6776.7090206@start.ca>
 <20130630143427.GA10035@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130630143427.GA10035@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > You know, either the "long" or the "offline" SMART test routines do exactly
> > > that on any spinning rust device with a firmware that is not utterly broken.
> > > 
> > > The HDD's firmware will rewrite, and even reallocate any "weak" sectors
> > > found by the surface scan.
> > > 
> > 
> > The drives I have tried this on (smartctl -t long),
> > abort at the first bad sector.  Not useful.
> 
> Which vendor?  The Seagates I have on hand are not that crappy, for example
> (their issues are subpar mechanics and the resulting high rate of failure,
> but the firmware at least is not a piece of crap)...

Are you sure? I seem to have firmware issues:

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Momentus 5400.6 series

... and yes, -t long terminates after first error :-(.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
