Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbaJ3Ox2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:53:28 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:38474 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaJ3Ox1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:53:27 -0400
MIME-Version: 1.0
In-Reply-To: <1414680302.2406.55.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net> <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net> <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net> <20141027092804.GB9807@amd>
 <1414420292.30379.55.camel@hadess.net> <54513DDC.2020700@amacapital.net>
 <20141029202616.GC5000@thunk.org> <20141029211608.GA32576@amd> <1414680302.2406.55.camel@hadess.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Oct 2014 07:53:05 -0700
Message-ID: <CALCETrXWha=rYB5hzg7xuB-ztw6MGRi=Q9nrJu1mZp6d=US8+A@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
To: Bastien Nocera <hadess@hadess.net>
Cc: Pavel Machek <pavel@ucw.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 7:45 AM, Bastien Nocera <hadess@hadess.net> wrote:
> On Wed, 2014-10-29 at 22:16 +0100, Pavel Machek wrote:
>> On Wed 2014-10-29 16:26:16, Theodore Ts'o wrote:
>> > On Wed, Oct 29, 2014 at 12:19:56PM -0700, Andy Lutomirski wrote:
>> > > For a tablet, isn't the relevant piece of information whether the power
>> > > button was recently pressed, not whether the power button caused the wakeup?
>> >
>> > For Android L devices, it has been reported that the device might
>> > power up its screen fully (note I didn't say 'wake up') automatically
>> > when it detects that you are picking it up, or when you double-tap the
>> > screen.  It also reportedly has a low power black and white "ambient
>> > display" (ala the Android Wear devics) which allows you to see
>> > notifications without waking up the phone all the way[1].  (All of
>> > this assuming appropriate hardware support, of course.)
>> >
>> > [1] http://www.androidauthority.com/ambient-display-lollipop-541198/
>> >
>> > Which goes back to the concept of having a "suspend" mode is legacy
>> > thinking.  Modern devices will soon have not just a "awake" and a
>> > "asleep" modes; there will be (well, is now) a much wider spectrum of
>> > modes, with the goal of using the minimum amount of power while still
>> > providing use functionality to the user.
>>
>> Actually Maemo people (on Nokia N900 and friends) got it right: unlike
>> android devices, it does not suspend to RAM at any point, and still
>> has reasonable battery life.
>
> Android devices don't suspend to RAM. Neither do Tizen devices AFAIK.
>
>> So I agree -- using suspend to RAM on "active" cell phone is just a
>> bad design.
>
> I don't think anyone was discussing cell phones in particular in this
> thread, and knowing when user-space got woken up because of the baseband
> processor having information for us would still be useful.
>

You still haven't addressed what problem this solves that isn't solved
by merely knowing whether the baseband processor has useful
information.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
