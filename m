Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKUTIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:08:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaKUTIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:08:43 -0500
Date: Fri, 21 Nov 2014 20:08:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141121190839.GA26833@amd>
References: <1413881397.30379.7.camel@hadess.net>
 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net>
 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
 <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
 <1414419579.30379.49.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414419579.30379.49.camel@hadess.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Mon 2014-10-27 15:19:39, Bastien Nocera wrote:

> > Now, I do think knowing which IRQ did bring you out of suspend is
> > useful, but mostly for power-debugging when you're trying to optimize
> > battery life. But for userland logic, I think its far too prone to
> > races.
> 
> I also cannot know, from user-space, whether Wake-On-LAN,
> Wake-On-Wireless-LAN, or the Wi-Fi card's "network proximity" triggered
> coming out of suspend for example.
> 
> I can certainly check for the status of the lid, but I wouldn't know
> whether a button was pressed to turn the machine back on, as the
> firmware would eat that.

If the firmware eats that, I'd call it "firmware bug"... and if we
could work around it by synthetizing button press, yes, we should do
that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
