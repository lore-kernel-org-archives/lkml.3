Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbaDIFbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:31:18 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59759 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaDIFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:31:14 -0400
Date: Wed, 9 Apr 2014 07:31:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL 00/10] perf/core improvements and fixes
Message-ID: <20140409053109.GA26139@gmail.com>
References: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
 <8738hnk3dg.fsf@tassilo.jf.intel.com>
 <CAM9d7ciP4tLUmR-soEKH3nf6=XC5evKGfuQW1fUGA8Z42U3xCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7ciP4tLUmR-soEKH3nf6=XC5evKGfuQW1fUGA8Z42U3xCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Andi,
> 
> On Wed, Apr 9, 2014 at 4:50 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > Jiri Olsa <jolsa@redhat.com> writes:
> >
> >> hi Ingo,
> >> please consider pulling
> >
> > So who actually maintains perf user space now?
> >
> > I have at least 4 perf user patchkits/bug fixes pending, but 
> > Arnaldo hasn't answered any email for weeks.

So a bit of background: sloppy, abusive contributors not willing to 
change get ignored after some time. For example Andi got such a bad 
track record in the x86 and perf space with me that all your mails go 
to /dev/null currently. (I only saw this one because Namhyung replied 
to it.)

Andi, as I explained it to you previously, if you want me to merge 
patches from you then you need to 1) improve the way you work 2) send 
it to someone who is willing to deal with you and sign off on it and 
forward it to me.

Seems like you managed to burn up your goodwill with Arnaldo as well. 
You need to find someone else willing to pay the expense of dealing 
with your passive-aggressive style.

Just a quick example of your abuse: for example you know it perfectly 
well that perf is well maintained, a simple 'git log tools/perf/' will 
tell you that there's a steady stream of patches going in and that 
perf contributors are busy.

Yet in this mail you actually lie about that: you pretend that you 
don't know that most Linux maintainers have trouble working with you, 
you pretend that perf is "unmaintained", you pretend that you don't 
know who is maintaining it, just to create unfair pressure on Arnaldo 
...

That kind of approach really sucks, and if you run out of people's 
patience with petty office tactics like that then you should not fault 
them, you should fault yourself.

Thanks,

	Ingo
