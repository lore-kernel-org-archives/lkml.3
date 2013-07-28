Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3G1Nhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 09:37:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43770 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3G1Nha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 09:37:30 -0400
Date: Sun, 28 Jul 2013 15:37:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
        lauri.leukkunen@nokia.com
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130728133728.GA5382@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130719181416.GA1204@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719181416.GA1204@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'd like to convert Nokia N900 to device tree.
> > 
> > Unfortunately, serial port is not easily available (very special cable
> > would be needed, does someone know where to get one?)
> 
> One way to get one is building it yourself. I finished mine yesterday:
> 
> http://elektranox.org/n900/adapter/index.html

Nice but a bit above my hardware hacking skills. For now, I'm using
automated scripts to run qemu... (They are available at 

http://tui.cvs.sourceforge.net/viewvc/tui/tui/auto/

). They should allow automated testing for regressions and automatic
bisect.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
