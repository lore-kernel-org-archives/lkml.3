Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbbADV1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 16:27:19 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43040 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752807AbbADV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 16:27:17 -0500
Date: Sun, 4 Jan 2015 21:26:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150104212659.GC12302@n2100.arm.linux.org.uk>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd>
 <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 04:20:57PM -0500, Nicolas Pitre wrote:
> On Sun, 4 Jan 2015, Linus Torvalds wrote:
> 
> > On Sun, Jan 4, 2015 at 12:56 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > >
> > > It wasted a lot of people's time before by simply being there and wrong
> > > before it was removed.  It's only a matter of whose time you want to
> > > waste.  Really.
> > 
> > Really. Shut up.
> > 
> > The whole "no regressions" thing is very much about the fact that we
> > don't waste users time.
> 
> I was talking about users time all along.
> 
> Never mind.  I'm sorry for the NAK and sorry for attempting to start a 
> discussion to find a better replacement.

Nico,

I encourage you *not* to back down like this.  Linus is right in so far
as the regressions issue, but he is *totally* wrong to do the revert,
which IMHO has been done out of nothing more than spite.

Either *with or without* the revert, the issue still remains, and needs
to be addressed properly.

With the revert in place, we now have insanely small bogomips values
reported via /proc/cpuinfo when hardware timers are used.  That needs
fixing.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
