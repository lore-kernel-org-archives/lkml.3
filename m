Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3IRNa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:30:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56167 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IRNa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:30:26 -0400
Date: Wed, 18 Sep 2013 15:30:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, freemangordon@abv.bg,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
Message-ID: <20130918133025.GB2953@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309172128.42514@pali>
 <20130918014942.GD19817@radagast>
 <201309181020.15245@pali>
 <CAAwP0s1Ou7Nrq7GhnHX71TFCrTFg=nqUh+GsAJhN8DjZGsF4QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAwP0s1Ou7Nrq7GhnHX71TFCrTFg=nqUh+GsAJhN8DjZGsF4QQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > So will you do that? Or it is needed to resend this one line
> >> > hunk again in new email again?
> >>
> >> new patch, new email
> >
> > Guys, WHY ARE YOU SO STUPID AND ARROGANT?
> >
> > Sorry but, need to copy full isolated patch/hunk from one mail to
> > another is hassling. So what you want from me? Do all those non
> > sense working only because yesterday you had bad day? Or what?
...
> 
> Hi Pali,
> 
> There is no need to be rude.
> 
> Felipe asked you to do the split since he believes that the notifier
> chain call for musb xceiv and the twl->phy notifier head init should
> be done in two separate patches.

Actually, there is need to be rude, because Felipe fails to act as
maintainer. Instead of fixing bugs in his code, he bounces bugfix
patches, points people to random READMEs and wastes everyones time.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
