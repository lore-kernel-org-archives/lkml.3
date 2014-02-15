Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaBOWaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 17:30:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56885 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaBOWaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:30:08 -0500
Date: Sat, 15 Feb 2014 23:30:06 +0100
From: Pavel Machek <pavel@denx.de>
To: Sebastian Reichel <sre@debian.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20140215223006.GA19186@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <201312301531.29768@pali>
 <20131230145250.GA16904@earth.universe>
 <201401082236.25135@pali>
 <CAHYPw2EJC9RwgzXmGuQgh5_L6EMtS7MW8N3u2dR8KeVc0kb43g@mail.gmail.com>
 <20140214172802.GA26969@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214172802.GA26969@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> > Firmware files are available for download from nemo project:
> > >> >
> > >> > https://api.merproject.org/public/source/nemo:devel:hw:ti:om
> > >> > ap3:n900/bcm-bt-firmware/bcm-bt-firmware-0.21rc3.tar.bz2
> > >> > https://api.merproject.org/public/source/nemo:devel:hw:ti:o
> > >> > map3:n950-n9/ti-wl1273-bt-firmware/bt-firmware-ti1273_0.23+0
> > >> > m6.tar.gz
> > >>
> > >> Would be nice to have them added to the linux-firmware.git.
> > >
> > Now when driver is queued for staging, can somebody add firmware files
> > to linux-firmware repository? Note that without firmware files, driver
> > not working...
> 
> I just had a look at the file for the Nokia N900
> (bcm-bt-firmware-0.21rc3.tar.bz2) and I think the license is too
> restrictive for linux-firmware.git. Actually I can't see any
> statement allowing redistribution. For reference this is the license
> text:
> 
> Copyright (c) Nokia Corporation 2010
> All Rights Reserved.
> 
> This material, including documentation and any related computer programs, is
> protected by copyright controlled by Nokia Corporation. All rights are
> reserved. Modifying, adapting and/or translating, any or all of this material
> requires the prior written consent of Nokia. Distribution for commercial
> purposes not allowed without prior written approval from Nokia.

With my lingvistics hat on, this says "distribution for non-commercial
purposes is ok". (Because otherwise, they would say "Distribution not
allowed without ...") 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
