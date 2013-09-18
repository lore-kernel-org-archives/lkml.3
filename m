Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3IROfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:35:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59786 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3IROfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:35:39 -0400
Date: Wed, 18 Sep 2013 16:35:37 +0200
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
Message-ID: <20130918143537.GA4914@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309172128.42514@pali>
 <20130918014942.GD19817@radagast>
 <201309181020.15245@pali>
 <CAAwP0s1Ou7Nrq7GhnHX71TFCrTFg=nqUh+GsAJhN8DjZGsF4QQ@mail.gmail.com>
 <20130918133025.GB2953@amd.pavel.ucw.cz>
 <CAAwP0s0nGthkm9Bp1ug23Rtz6-sbR60FFTSfd-Cj9wKMU0RBEA@mail.gmail.com>
 <20130918142203.GD3748@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918142203.GD3748@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > gave feedback. If the sender doesn't want to take his feedback into
> > account and prefer to send pretty insulting emails instead that is his
> > choice but I would say that is this not the greatest approach to get
> > your code merged (to say the least).
> 
> Clearly not. But Pali found bug in code Felipe should
> maintain. Instead of "thank you for bug report, I applied this one
> line of your code to fix it", Pali got "new patch, new email" for his
> efforts. That is how you train dogs, not how you should treat kernel
> contributors.
> 
> Now, it is possible that Felipe just has problems with english, as he
> called me piece of wood in https://lkml.org/lkml/2013/9/17/476 , but
> he appears more arogant than usual over email.

Actually he called me "piece of wood with garbage in it". I guess I
have right to be offended. I'm baby in the next email. Hmm.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
