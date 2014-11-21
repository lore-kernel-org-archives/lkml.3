Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaKUURO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:17:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49364 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaKUURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:17:11 -0500
Date: Fri, 21 Nov 2014 21:17:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 8/8] MAINTAINERS: add at91 power and memory entries
Message-ID: <20141121201709.GC26833@amd>
References: <1414451377-11053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1414451377-11053-9-git-send-email-alexandre.belloni@free-electrons.com>
 <1414451837.18896.14.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414451837.18896.14.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-27 16:17:17, Joe Perches wrote:
> On Tue, 2014-10-28 at 00:09 +0100, Alexandre Belloni wrote:
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> []
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -871,6 +871,25 @@ M:	Boris Brezillon <boris.brezillon@free-electrons.com>
> >  S:	Maintained
> >  F:	drivers/clk/at91
> >  
> > +ARM/ATMEL AT91 Poweroff driver
> > +M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	Maintained
> > +F:	drivers/power/reset/at91-poweroff.c
> > +
> > +ARM/ATMEL AT91 Reset driver
> > +M:	Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	Maintained
> > +F:	drivers/power/reset/at91-reset.c
> 
> It's traditional to use upper case section descriptions.

Actually, it might be nice to switch to normal case
descriptions. Easier to search for...


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
