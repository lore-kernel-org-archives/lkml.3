Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaJSIIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 04:08:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48542 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaJSIH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 04:07:59 -0400
Date: Sun, 19 Oct 2014 10:07:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
Message-ID: <20141019080756.GA14903@amd>
References: <20141015111641.GC7792@gaast.net>
 <CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
 <CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
 <543F049F.5090605@gaast.net>
 <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
 <543F9182.9000004@gaast.net>
 <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
 <544033CF.3080104@gaast.net>
 <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
 <5442FE58.5020700@gaast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5442FE58.5020700@gaast.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-10-19 00:57:12, Wilmer van der Gaast wrote:
> (Resending, forgot to hit reply-to-all.)
> 
> Hello Yinghai,
> 
> On 18-10-14 22:28, Yinghai Lu wrote:
> >
> > Please apply attached debug patch on top of v3.17 and boot with
> > "debug ignore_loglevel initcall_debug no_console_suspend".
> >
> > Hope we can find out which nb notifier cause problem.
> >
> Did that. Strangely, or better said, quite annoyingly, I'm now getting no
> output anymore at all on the third resume! :-(
> 
> I could try non-serial instead if you think that's worth a shot, but the
> most annoying thing is that my video doesn't get initialised properly after
> resume unless I have the tainting nvidia driver loaded. I could try if
> nouveau helps.

Tainting should not be a problem. If it works for you, it works...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
