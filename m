Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab3I0KW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:22:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41023 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3I0KW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:22:56 -0400
Date: Fri, 27 Sep 2013 12:22:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: thinkpad x60: critical thermal shutdown does not work (and
 ethernet overheats)
Message-ID: <20130927102254.GC18121@amd.pavel.ucw.cz>
References: <20120515181004.GA2499@elf.ucw.cz>
 <20130923095814.GA2052@Nokia-N900>
 <20130923120256.GB29847@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923120256.GB29847@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-09-23 09:02:56, Henrique de Moraes Holschuh wrote:
> On Mon, 23 Sep 2013, Pavel Machek wrote:
> > > I have rather old thinkpad x60 here. Long time ago, I noticed that on
> > > high continuous ethernet load, it shuts itself down in regular
> > > way. I traced it down to overheat, followed by ACPI signaling system
> > > to go down.
> > 
> > just to wrap the story up... after fixing pcie aspm problems,
> > ethernet apparently stopped overheating.
> 
> And that means a new kernel with fixed ASPM handling, or disabling ASPM
> entirely, or what?

That means single-line forcing ASPM to be disabled, even through linux
is normally not able to disable ASPM when it is not supported by the
BIOS. Someone at Intel knows about the problem, hopefully they will
present some better solution...

> Good to know it can be handled by a software fix, though!

Yes :-). [I wonder if it happens on other X60 machines, too?]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
