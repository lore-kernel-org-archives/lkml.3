Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaAFA16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 19:27:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54242 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaAFA15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:27:57 -0500
Date: Mon, 6 Jan 2014 01:27:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v4] Bluetooth: Add hci_h4p driver
Message-ID: <20140106002755.GC27517@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140103010519.GA27678@earth.universe>
 <20140105223250.GB27517@amd.pavel.ucw.cz>
 <20140105230155.GA2681@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140105230155.GA2681@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > The drivers can still be initialized the old way using pdata quirks
> > > until all drivers are converted, but I think this driver can simply
> > > be prepared for DT directly:
> > 
> > Well, normally DT support means a bit of argumentation and bikeshed
> > painting... I believe it would be better to get the driver in as-is
> > and then work on adding DT support.
> 
> Maybe. Especially the UART reference may result in some discussion.
> But having the discussion early means its finished earlier :)

Well, merging the basic driver does not mean discussion can't start
early. If it is going to be complex, that's a very good reason to do
it in separate step. That is, have a working driver, then add device
tree support.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
