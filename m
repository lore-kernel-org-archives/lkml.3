Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbaJ3Opw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:45:52 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36577 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759987AbaJ3Opv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:45:51 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414680302.2406.55.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Oct 2014 15:45:02 +0100
In-Reply-To: <20141029211608.GA32576@amd>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net> <20141027092804.GB9807@amd>
	 <1414420292.30379.55.camel@hadess.net> <54513DDC.2020700@amacapital.net>
	 <20141029202616.GC5000@thunk.org> <20141029211608.GA32576@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 22:16 +0100, Pavel Machek wrote:
> On Wed 2014-10-29 16:26:16, Theodore Ts'o wrote:
> > On Wed, Oct 29, 2014 at 12:19:56PM -0700, Andy Lutomirski wrote:
> > > For a tablet, isn't the relevant piece of information whether the power
> > > button was recently pressed, not whether the power button caused the wakeup?
> > 
> > For Android L devices, it has been reported that the device might
> > power up its screen fully (note I didn't say 'wake up') automatically
> > when it detects that you are picking it up, or when you double-tap the
> > screen.  It also reportedly has a low power black and white "ambient
> > display" (ala the Android Wear devics) which allows you to see
> > notifications without waking up the phone all the way[1].  (All of
> > this assuming appropriate hardware support, of course.)
> > 
> > [1] http://www.androidauthority.com/ambient-display-lollipop-541198/
> > 
> > Which goes back to the concept of having a "suspend" mode is legacy
> > thinking.  Modern devices will soon have not just a "awake" and a
> > "asleep" modes; there will be (well, is now) a much wider spectrum of
> > modes, with the goal of using the minimum amount of power while still
> > providing use functionality to the user.
> 
> Actually Maemo people (on Nokia N900 and friends) got it right: unlike
> android devices, it does not suspend to RAM at any point, and still
> has reasonable battery life.

Android devices don't suspend to RAM. Neither do Tizen devices AFAIK.

> So I agree -- using suspend to RAM on "active" cell phone is just a
> bad design.

I don't think anyone was discussing cell phones in particular in this
thread, and knowing when user-space got woken up because of the baseband
processor having information for us would still be useful.

