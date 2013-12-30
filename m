Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3L3MZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:25:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59867 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab3L3MZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:25:52 -0500
Date: Mon, 30 Dec 2013 13:25:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230122549.GA21519@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
 <20131230121350.GB31236@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230121350.GB31236@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > @@ -0,0 +1,1357 @@
> > > +/*
> > > + * This file is part of hci_h4p bluetooth driver
> > > + *
> > > + * Copyright (C) 2005-2008 Nokia Corporation.
> > > + *
> > > + * Contact: Ville Tervo <ville.tervo@nokia.com>
> > 
> > I think you can just remove the contact names since I think nobody of the original authors is still working at Nokia and I bet this emails addresses just do not work anymore.
> > 
> 
> I sent him an email with question. I guess we should move Ville to
> CREDITS?

You just won the bet :-).

<ville.tervo@nokia.com>: host mx1.nokia.com[147.243.142.136] said: 550
5.1.1
    <ville.tervo@nokia.com>... User unknown (in reply to RCPT TO
    command)

(I'd bet that way, too, but I thought it should be checked).

Anyway, time to catch some sunlight while it lasts...

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
