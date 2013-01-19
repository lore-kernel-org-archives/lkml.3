Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3ASRCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 12:02:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57657 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3ASRCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 12:02:12 -0500
Date: Sat, 19 Jan 2013 18:02:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, arnd@arndb.de
Subject: Re: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Message-ID: <20130119170204.GA2956@amd.pavel.ucw.cz>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
 <20121120134737.GB8111@elf.ucw.cz>
 <20121120135901.GA9227@elf.ucw.cz>
 <50AB9116.3090401@synopsys.com>
 <20130118194631.GA5119@amd.pavel.ucw.cz>
 <50FA9277.8030509@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FA9277.8030509@synopsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Ok, plus there's already computing standard called "arc".
> >>>
> >>> https://www.linux-mips.org/wiki/ARC
> >>>
> >>> What about calling the architecture "sarc" or "syarc" ?
> >> I think it would be best use of everybody's time if you could focus on
> >> the technical content of the port rather than the name. It has been like
> >> that for +10 years and I don't intend to make the kernel port name
> >> different from THE arch name itself.
> > Yeah, and it is best use of reviewers time to confuse them with
> > one-letter difference to very popular architecture... and use three
> > letter acronym that was already taken.
> >
> > In this state, I hope your port never gets merged. Yes, I got used to
> > do cd a<tab>/ar<tab>.
> 
> Although I really don't want to spend time arguing with you but still ...... if
> you had a neighbor with same name as your friend your strategy most likely would
> be to force one of them to change names - kind of seems funny and
> stupid.

Yeah, imagine creating "/bin/mr" that would be du equivalent. How many
people would delete their files by mistake? 

> Having said that, despite all the ranting so far, you've not managed to comment on
> a single line of the actual code, which is more funny and stupid. So

Yeah, you tricked me into reviewing your code. No, I will not do more
reviews for you. Yes, I bet I'm not the only one, and I bet that
mistake will happen about once per developer.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
