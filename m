Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaFYWf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:35:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43354 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaFYWfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:35:25 -0400
Date: Thu, 26 Jun 2014 00:35:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140625223522.GA5923@xo-6d-61-c0.localdomain>
References: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
 <20140514155759.GB9723@amd.pavel.ucw.cz>
 <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-06-09 13:03:31, Jiri Kosina wrote:
> On Mon, 9 Jun 2014, Pavel Machek wrote:
> 
> > > > Strange. It seems 3.15 with the patch reverted only boots in 30% or so
> > > > cases... And I've seen resume failure, too, so maybe I was just lucky
> > > > that it worked for a while.
> > > 
> > > git bisect really likes 25f397a429dfa43f22c278d0119a60 - you're about
> > > the 5th report or so that claims this is the culprit but it's
> > > something else. The above code is definitely not used in i915 so bogus
> > > bisect result.
> > 
> > Note I did not do the bisect, I only attempted revert and test.
> > 
> > And did three boots of successful s2ram.. only to find out that it
> > does not really fix s2ram, I was just lucky :-(.
> > 
> > Unfortunately, this means my s2ram problem will be tricky/impossible
> > to bisect :-(.
> 
> Welcome to the situation I have been in for past several months.

Ok, so I have set up machines for ktest / autobisect, and found out that 3.16-rc1 no
longer has that problem. Oh well, bisect would not be fun, anyway...

										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
