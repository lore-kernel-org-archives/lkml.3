Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaJFVOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:14:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59243 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:14:33 -0400
Date: Mon, 6 Oct 2014 23:14:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: 3.17-rc5: kernel oops when exiting X under heavy load
Message-ID: <20141006211430.GA31880@amd>
References: <20141003231109.GA4530@amd>
 <20141006181202.GA22781@dtor-ws>
 <20141006204526.GA28905@amd>
 <20141006210358.GA39707@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006210358.GA39707@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-10-06 14:03:58, Dmitry Torokhov wrote:
> On Mon, Oct 06, 2014 at 10:45:26PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > From the backtrace, it looks evdev related...?
> > > 
> > > Hmm, looks like it...
> > 
> > I don't think I can repeat that. I was doing crazy stuff at that
> > moment. (Typo fixes suggested below).
> > 
> > Thanks,
> > 								Pavel
> > 
> > Input: evdev - fix EVIOCG{type} ioctl
> > 
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > The 'max' size passed into the function is measured in number of bits
> > (KEY_MAX, LED_MAX, etc) so we nedd to convert it accoidingly before tyring
> > 
> > ###                           need               accordingly(?)     trying
> 
> Thanks, I'll fix them up.

No problem. BTW, I guess this should go to 3.17-stable at least, and
probably older stable releases, too...?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
