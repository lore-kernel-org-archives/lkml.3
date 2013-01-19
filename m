Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3ASKPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:15:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43929 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3ASKPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:15:51 -0500
Date: Sat, 19 Jan 2013 11:15:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
Message-ID: <20130119101549.GA5774@amd.pavel.ucw.cz>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
 <50AB9116.3090401@synopsys.com>
 <20130118194631.GA5119@amd.pavel.ucw.cz>
 <201301182217.46142.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301182217.46142.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yeah, and it is best use of reviewers time to confuse them with
> > one-letter difference to very popular architecture... and use three
> > letter acronym that was already taken.
> > 
> > In this state, I hope your port never gets merged. Yes, I got used to
> > do cd a<tab>/ar<tab>.
> 
> You already lost that capability with the addition of arm64. As you
> may remember, that one was proposed to be called arch/aarch64 at first,
> which wasn't very popular ;-)

Actually, with arm26, which is older IIRC. But tab still works there,
just will not fill the last /, and you can't mistake arm64 with arm in
filenames etc -- different length.

> A lot of people are familiar with the ARC name, it's been around
> for decades and has sold billions of CPUs under that name, likely
> more than x86 or mips (still dwarfed by ARM of course). They've just

Well, it seems that mips people were aware of the ARC name, it just
meant something different:

https://www.linux-mips.org/wiki/ARC

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
