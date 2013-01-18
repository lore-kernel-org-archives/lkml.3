Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3ARTqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:46:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36831 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3ARTqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:46:33 -0500
Date: Fri, 18 Jan 2013 20:46:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, arnd@arndb.de
Subject: Re: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Message-ID: <20130118194631.GA5119@amd.pavel.ucw.cz>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
 <20121120134737.GB8111@elf.ucw.cz>
 <20121120135901.GA9227@elf.ucw.cz>
 <50AB9116.3090401@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB9116.3090401@synopsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-11-20 19:47:58, Vineet Gupta wrote:
> On Tuesday 20 November 2012 07:29 PM, Pavel Machek wrote:
> > On Tue 2012-11-20 14:47:37, Pavel Machek wrote:
> >> Hi!
> >>
> >>>     https://raw.github.com/vineetgarc/publish/master/ELCE-2012-ARC-Linux.pdf
> >>>
> >>> All comments/criticisms are welcome !
> >> Huh. arch/arc is very similar to arch/arm. So similar that it took me
> >> 10 minutes to figure out. I guess theres no alternate name arc could
> >> use?
> > Hmm... "Advanced Risc"... :-(.
> >
> > Ok, plus there's already computing standard called "arc".
> >
> > https://www.linux-mips.org/wiki/ARC
> >
> > What about calling the architecture "sarc" or "syarc" ?
> 
> I think it would be best use of everybody's time if you could focus on
> the technical content of the port rather than the name. It has been like
> that for +10 years and I don't intend to make the kernel port name
> different from THE arch name itself.

Yeah, and it is best use of reviewers time to confuse them with
one-letter difference to very popular architecture... and use three
letter acronym that was already taken.

In this state, I hope your port never gets merged. Yes, I got used to
do cd a<tab>/ar<tab>.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
