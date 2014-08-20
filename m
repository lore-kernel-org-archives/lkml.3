Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaHTCqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:46:45 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54932 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHTCqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:46:44 -0400
Date: Wed, 20 Aug 2014 04:46:38 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reply-To: 
In-Reply-To: <1408466497-25640-1-git-send-email-dmitry.torokhov@gmail.com>
X-Priority: none

Hi,

> Gameport support hasn't been working well ever since cpufreq became
> mainstream and it becomes increasingly hard to find hardware and
> software
> that would run on such old hardware.

Given that I'm puzzled why one would want to deprecate a whole subsystem
which appears to be supported by a whole 14 different PCI sound card
drivers (where the ones I'm owning hardware of are intended to be in
active maintenance) and only 3 ISA-based ones, I'm missing several
details and justifications of that decision here (perhaps there was a
prior discussion/activity that I'm missing?).

Also, I'm left wondering why e.g. my Athlon XP system (a very popular
choice for longer times) would be affected by Cpufreq...
And there are no details on how exactly cpufreq is a problem or how this
timing issue could be fixed...
The obvious workaround for such an ensuing dearth of hardware support
could be USB 15-pin gameport adapters - but are they even supported on
Linux? Haven't seen info on this...
And even if supported, these adapters (at least the non-perfect ones, as
can be seen from reviews on a well-known online shop site) are said to
be hit-or-miss.

http://www.flightsim.com/vbfs/showthread.php?238938-joystick-GamePort-to-USB-adapter-question
http://reviews.thesource.ca/9026/2600164/nexxtech-usb-gameport-adapter-reviews/reviews.htm

If we keep removing functionality like this, then why stop short of
removing x86 32bit as a whole? By having Linux support nicely restricted
to hardware made within the last 5 years, we would surely be doing the
planned-obsolescence Micro$oft "ecosystem" (what was ecological about
this again?) a huge favour...

We already have an IMHO dangerous state in support of somewhat less mainstream
hardware, so do we want to keep furthering that?

Could we have more details/discussion prior to activities to remove
whole subsystems?

Thanks,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
