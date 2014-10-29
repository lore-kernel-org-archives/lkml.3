Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbaJ2VQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:16:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55026 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbaJ2VQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:16:11 -0400
Date: Wed, 29 Oct 2014 22:16:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Bastien Nocera <hadess@hadess.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141029211608.GA32576@amd>
References: <1413881397.30379.7.camel@hadess.net>
 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net>
 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
 <20141027092804.GB9807@amd>
 <1414420292.30379.55.camel@hadess.net>
 <54513DDC.2020700@amacapital.net>
 <20141029202616.GC5000@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029202616.GC5000@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-10-29 16:26:16, Theodore Ts'o wrote:
> On Wed, Oct 29, 2014 at 12:19:56PM -0700, Andy Lutomirski wrote:
> > For a tablet, isn't the relevant piece of information whether the power
> > button was recently pressed, not whether the power button caused the wakeup?
> 
> For Android L devices, it has been reported that the device might
> power up its screen fully (note I didn't say 'wake up') automatically
> when it detects that you are picking it up, or when you double-tap the
> screen.  It also reportedly has a low power black and white "ambient
> display" (ala the Android Wear devics) which allows you to see
> notifications without waking up the phone all the way[1].  (All of
> this assuming appropriate hardware support, of course.)
> 
> [1] http://www.androidauthority.com/ambient-display-lollipop-541198/
> 
> Which goes back to the concept of having a "suspend" mode is legacy
> thinking.  Modern devices will soon have not just a "awake" and a
> "asleep" modes; there will be (well, is now) a much wider spectrum of
> modes, with the goal of using the minimum amount of power while still
> providing use functionality to the user.

Actually Maemo people (on Nokia N900 and friends) got it right: unlike
android devices, it does not suspend to RAM at any point, and still
has reasonable battery life.

So I agree -- using suspend to RAM on "active" cell phone is just a
bad design.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
