Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaAGMPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:15:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59525 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaAGMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:15:05 -0500
Date: Tue, 7 Jan 2014 13:15:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Luciano Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2 00/16] wl1251 patches from linux-n900 tree
Message-ID: <20140107121502.GB10358@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <201312311047.30147@pali>
 <20140106200050.GG10885@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106200050.GG10885@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Second version contains new patch for fixing NULL pointer
> > > dereference which sometimes cause kernel panic and fixes code
> > > suggested by Pavel Machek.
>  
> > So far, there are no new comments for patches 01, 03-13 and 16. 
> > Are there any other problems with that patches or can be accepted 
> > for upstream?
>  
> They are probably fine to merge now.  Of course, I was still deleting
> wl12xx patches when they were originally posted, so I'll need someone
> to resend the patches to me...

Patches should be in your inbox now, with subjects "[PATCH v3 13/13]
wl1251:". I hand selected patches 01, 03-13 and 16. I was doing
forwarding by hand, sorry for extra (fwd) in 06/13.

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
