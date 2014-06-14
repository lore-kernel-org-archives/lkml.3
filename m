Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaFNItT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 04:49:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaFNItP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 04:49:15 -0400
Date: Sat, 14 Jun 2014 10:49:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Drake <dsd@laptop.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, chris@printf.net,
        dsd@gentoo.org
Subject: Re: Kernel for olpc-1.75
Message-ID: <20140614084905.GB15326@Nokia-N900>
References: <20140607225356.GA5696@amd.pavel.ucw.cz>
 <CAMLZHHRsewk=YqWp_sKULSfqyejgUWcZMjFp-G388xqaQBbg-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHRsewk=YqWp_sKULSfqyejgUWcZMjFp-G388xqaQBbg-g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Sat, Jun 7, 2014 at 11:53 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > I broke installation on olpc-1.75, and I guess its time for it to
> > start running self-compiled kernel. (It still boots if I hold right
> > game key, but I can no longer control backlight. It does not boot at
> > all by default.)
> >
> > AFAICT, olpc.fth and zImage in the boot/ directory of USB disk should
> > do the trick.
> >
> > Unfortunately, 3.0 based kernels no longer compile with current tools,
> > so I tried this version (3.6 based).
> 
> Sorry but OLPC never progressed beyond shipping 3.0 on this hardware,
> and low-level development only really happens in maintenance mode at
> the moment.

Ok, wip-3.0 branch boots on the hardware. Good so far... but
touchpad does not work... If you have any idea about that...)

Redhat update kernel (yes, I made a mistake of installing that)
has broken backlight controls, and only boots in development
mode. Ideas here would be welcome, too...

> We did almost get a newer version working, but it had some unresolved
> issues that prevented us from shipping it to users. I'm not sure of
> the state of that arm-3.6 branch you are trying but I don't see
> anything wrong in your process. I would try early printascii() calls
> and a serial cable next.
> 
> Mainline won't run on the machine in any kind of usable state without
> quite a bit of work on drivers and DT (which comes from the firmware).
> I did once start on that but didn't manage to get even the initial
> easy patches past the Marvell maintainers :(

Ok, let me try to get machine into semi-working state, and
then I can think about updating kernels...
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
