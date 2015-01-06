Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbbAFV5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:57:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44759 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbAFV5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:57:49 -0500
Date: Tue, 6 Jan 2015 22:57:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106215744.GC13902@amd>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205413.GF32308@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106205413.GF32308@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-06 14:54:13, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jan 06, 2015 at 09:50:00PM +0100, Pavel Machek wrote:
> > On Tue 2015-01-06 14:28:57, Felipe Balbi wrote:
> > > On Tue, Jan 06, 2015 at 06:51:15PM +0100, Pavel Machek wrote:
> > > > 
> > > > On Tue 2015-01-06 11:25:45, Felipe Balbi wrote:
> > > > > On Tue, Jan 06, 2015 at 06:04:33PM +0100, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > In 3.18, sound is nice and clear.
> > > > > > 
> > > > > > In 3.19, sound is unusable. It produces nasty tone when it should be
> > > > > > quiet, and there's at least as much noise as is sound.
> > > > > > 
> > > > > > Unfortunately, list of mixers also changed (and there's cca 120
> > > > > > settings), but a) it does not work with the old list and b) nothing I
> > > > > > could figure out did make the sound usable. Some setting resulted in
> > > > > > even more noise.
> > > > > > 
> > > > > > Any idea what could have caused it?
> > > > > 
> > > > > $ git bisect start
> > > > > $ git bisect good v3.18
> > > > > $ git bisect bad
> > > > > 
> > > > > that'll help find what caused it.
> > > > 
> > > > Telling someone to do hard and time consuming job that probably will
> > > > not succeed, instead of actually providing help. Very very funny.
> > > 
> > > you're getting code for free, you're getting help for free. Not many
> > > people have N900s lying around. Running a bisection is just
> > > politeness.
> > 
> > Now you are speaking for yourself or for TI?
> 
> why bring my employer into the discussion ?

Because you are speaking of getting help for free, and I don't
remember getting any useful help from you; so I'd like to know who do
you speak for.

> > Thanks for your very valuable help. I know how to do a bisection,
> > thank you.
> 
> then please do it.

No, sorry, I don't think that would be reasonable use of my time at
this point. First steps are "confirm it happens on other N900 boards,
too", ruling out config issues at my part, and "try to get
verification from other development boards if they have same
problems", because most other boards are easier to work with.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
