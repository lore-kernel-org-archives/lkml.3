Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbaDXPWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:22:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaDXPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:21:57 -0400
Date: Thu, 24 Apr 2014 17:21:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: dinh@amd.pavel.ucw.cz, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: socfpga in 3.15-rc2
Message-ID: <20140424152156.GA22540@amd.pavel.ucw.cz>
References: <20140424125421.GA19526@amd.pavel.ucw.cz>
 <734n1i25ad.fsf@unicorn.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <734n1i25ad.fsf@unicorn.hi.pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Does socfpga boot for you on 3.15-rc2? Mainline worked on 3.14 pretty
> > well, but I get no output from serial from 3.15-rc2. Any ideas?
> >
> 
> You need:
> 
> [PATCH] clk: socfpga: fix clock driver for 3.15
> Message-Id: 1397481336-5592-1-git-send-email-dinguyen@altera.com

Thanks a lot, with that patch, I'm back to working system.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
