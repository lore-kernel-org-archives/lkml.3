Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaGVJ2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:28:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39517 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaGVJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:28:00 -0400
Date: Tue, 22 Jul 2014 11:27:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Joe Perches <joe@perches.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Evgeniy Polyakov <zbr@ioremap.net>, Wang YanQing <udknight@gmail.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        David Fries <David@fries.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: uvesafb.c: Cleaning up variable that is
 never used
Message-ID: <20140722092757.GA8796@amd.pavel.ucw.cz>
References: <1404564682-21983-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140721212527.GC3824@amd.pavel.ucw.cz>
 <CAFo99gYhrNR68mdJY=fn1x-+4U=6gdv=C4-Xn-w-YJAPSa5bBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gYhrNR68mdJY=fn1x-+4U=6gdv=C4-Xn-w-YJAPSa5bBQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-22 11:16:58, Rickard Strandqvist wrote:
> Hi
> 
> Sure, I agree. But as I thought that I would not change
> currentfunctionality, I would increase the chance that the patches were
> included. And it would of course also clarify this type of problem.

I'm trying to say that getting rid of the variables without changing
functionality might be wrong thing to do, for example in this case. It
looks like error handing is missing by mistake, and you are removing
traces saying that error handing is required here.

Dunno. Perhaps don't push patches where solution is not obvious?

Or push them but mark the place with fixme? 

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
