Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3IRNQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:16:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55573 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3IRNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:16:45 -0400
Date: Wed, 18 Sep 2013 15:16:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130918131644.GA2953@amd.pavel.ucw.cz>
References: <201302171616.50152@pali>
 <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
 <201303062112.06417@pali>
 <201309062234.05878@pali>
 <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-09-08 02:02:52, Aaro Koskinen wrote:
> Hi,
> 
> On Fri, Sep 06, 2013 at 10:34:05PM +0200, Pali Rohár wrote:
> > > --- /dev/null
> > > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> [...]
> > Ping, can you review this patch v2?
> 
> I don't think Tony will accept any new board stuff for RX-51/N900.
> See for example: http://marc.info/?l=linux-kernel&m=137629626213187&w=2
> 
> There should be initial Nokia N900 DTS file in 3.12-rc1, and we should
> continue converting this board fully to DT.

That's not reasonable. N900 is pretty far away from working with
device tree. Yes, I was able to get some bits merged, but that should
not be excuse to halt other N900 development.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
