Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaKRHm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:42:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42585 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaKRHm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:42:57 -0500
Date: Tue, 18 Nov 2014 08:42:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, khilman@kernel.org,
        Tony Lindgren <tony@atomide.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>, Pali Roh?r <pali.rohar@gmail.com>,
        linux-omap@vger.kernel.org, freemangordon@abv.bg,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141118074254.GA4059@amd>
References: <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
 <20141106180335.GA21513@earth.universe>
 <20141113162155.GA8512@xo-6d-61-c0.localdomain>
 <20141113174534.GO26481@atomide.com>
 <20141113181803.GB984@fuloong-minipc.musicnaut.iki.fi>
 <20141116101248.GA32483@amd>
 <87vbmf1g75.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbmf1g75.fsf@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-11-16 13:29:50, Robert Jarzmik wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > On Thu 2014-11-13 20:18:04, Aaro Koskinen wrote:
> >> Hi,
> >> 
> >> On Thu, Nov 13, 2014 at 09:45:36AM -0800, Tony Lindgren wrote:
> >> > * Pavel Machek <pavel@ucw.cz> [141113 08:23]:
> >> > > OTOH ofono seems pretty reasonable. So I played a bit, and result
> >> > > is python/pygtk gui which can receive an sms, initiate a call, and
> >> > > report missed call. If someone wants to play, source is at
> >> > > 
> >> > > https://gitorious.org/tui/tui/source/b6141107e9341a1412720aed4b0d09143dfa2f4e:ofone
> >> > 
> >> > Pavel, care to fill in the the following type patch with some
> >> > instructions in the description now that you got it working?
> >> 
> >> Could we even have some "permanent" instructions under Documentation/?
> >
> > Something like this?
> >
> > commit 375d8d9f17433ade6afae91d4f34e170f0af04c4
> > Author: Pavel <pavel@ucw.cz>
> > Date:   Sun Nov 16 11:10:59 2014 +0100
> >
> > Add basic documentation for n900 testing.
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >
> > diff --git a/Documentation/cellphones.txt b/Documentation/cellphones.txt
> > new file mode 100644
> > index 0000000..d7e8e7a
> > --- /dev/null
> > +++ b/Documentation/cellphones.txt
> > @@ -0,0 +1,90 @@
> > +Running Linux on Cellphones
> > +===========================
> > +
> > +At this moment (2014), there are no cellphones completely supported by
> > +mainline kernel. Another problem is lack of hackable userspace to run
> > +on cellphone, even when kernel support is available.
> Hi Pavel,
> 
> There is the Mitac Mio A701. Very old but still it is there, with the kernel
> part maintained.
> 
> Userspace was based on QTopia in 2008. I don't maintain that part anymore
> though.
> 
> The GSM part relies on a simple ttyS device (modem has its internal flash), no
> real data at that time, or rather 2G only, but the 07.10 mux support was never
> included in Qtopia ...

Thanks for the info. 

I added 

"
+Mainline has support for Mitac Mio A701, but that having only 64MiB
+RAM, QTopia is the software to use there.
"
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
