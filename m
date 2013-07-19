Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab3GSLKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:10:30 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57601 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3GSLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:10:28 -0400
Date: Fri, 19 Jul 2013 13:10:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Willy Tarreau <w@1wt.eu>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130719111021.GD26716@gmail.com>
References: <20130715155202.GC29526@xanatos>
 <20130716210856.GF4994@xanatos>
 <CA+55aFwcT3pRjKKB3c+QPVZ3tREVKJwszE5EMwJ_eQTjPkOzXQ@mail.gmail.com>
 <4384290.4rZz7uttsZ@vostro.rjw.lan>
 <CA+55aFy=XOKNePc+buJovaBu-WVUHHh=J35SSG1HyraGqH6PXQ@mail.gmail.com>
 <20130717052250.GB14392@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717052250.GB14392@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

> On Tue, Jul 16, 2013 at 03:12:45PM -0700, Linus Torvalds wrote:
> > I react very strongly when somebody argues against fixing regressions.
> > Let's just say that there's too many years of baggage that I carry
> > around on that issue..
> > 
> > So that is definitely one of the things that make me go ballistic.
> > Buggy code isn't actually one of them. Bugs happen. Even really stupid
> > bugs happen, and happen to good people. They had a bad day, or it was
> > just a brainfart.  Not that I will be _polite_ about bad code, mind
> > you, and there might be some bad words in there, but it doesn't make
> > me blow up.
> > 
> > Being cavalier about known regressions is definitely the primary
> > trigger. I suspect there are others, but I can't seem to recall any
> > other particular hot-button issues right now. Maybe Sarah can post a
> > few more pointers..
> 
> Hmm... The only thing I can think of off the top of my head is that you 
> tend to hate it when someone puts the needs of their particular 
> architecture or distro at a higher priority than the needs of the kernel 
> community.  If they start to push crap code late in the merge window to 
> further their personal goals, you tend to blow up at them.  See the 
> 'deep throat' comment on the PE binary signing thread, for instance.
> 
> The timing of when incidents happen also seems to effect whether you get 
> triggered.  I suspect most of the incidents of you "blowing up" at 
> people happen during the merge window.

Of course timing matters:

 - there are times when a bad pull request can have worse effects, such as 
   shortly before -rc1 or shortly before -final - when many people will be 
   exposed to a new kernel for the first time.

 - timing can also sometimes show a certain level of dishonesty on the 
   developer's side: trying to slip in a bad tree near the end of the 
   merge window, before people can complain it ...

 - there are times when Linus naturally more vulnerable to not having 
   enough time to think things through: such as when he is pulling a dozen 
   trees per day, during the merge window.

Dishonesty, bad timing, running a bad Git flow and making irreversible ABI 
mistakes [of which refusing to fix app regressions is one sort] are all 
hot button issues for Linus, and it's a pretty natural list I think: 
because they are the least actionable, most persistent and thus riskiest 
"meta" problems possible in a kernel project.

Some of Linus's "worst" flames had two or more of these hot button issues 
mixed together. Sometimes a maintainer can get away with a mistake (most 
likely Linus does not notice the mistake) but in general it's all pretty 
consistent.

All in one, with all due respect, I don't think your complaints voiced so 
far against Linus have much merit :-/ I think you'll experience it first 
hand once you become a top level maintainer.

Having said that, I do share your concern that women are more offput by 
the widespread 'manly' talk on lkml: LKML is filled with testosterone. I 
think your solution to create a separate culture is a good one - and 
eventually the two cultures will counter-balance each other in a good way 
and will maybe merge. I cannot think of a better solution either, and I 
fully support your efforts: it's one of the big unsolved problems of Linux 
kernel development.

Thanks,

	Ingo
