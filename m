Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3KKNw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:52:29 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63551 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3KKNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:52:21 -0500
Date: Mon, 11 Nov 2013 14:52:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
Message-ID: <20131111135216.GB8781@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
 <20131111113218.GF15810@gmail.com>
 <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
 <20131111124953.GA6765@gmail.com>
 <CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
 <20131111132812.GB7258@gmail.com>
 <CAMP44s2NYKfrYngTEN5+mPPHOJZLNmSVd3n8k5QNv_=Lpvncsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2NYKfrYngTEN5+mPPHOJZLNmSVd3n8k5QNv_=Lpvncsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Mon, Nov 11, 2013 at 7:28 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >
> >> On Mon, Nov 11, 2013 at 6:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >
> >> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >> >
> >> >> On Mon, Nov 11, 2013 at 5:32 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >> >
> >> >> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >> >> >
> >> >> >> We want to calculate the blinks per second, and instead of making it 5
> >> >> >> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
> >> >> >> per second.
> >> >> >
> >> >> > Please use the customary changelog style we use in the kernel:
> >> >> >
> >> >> >   " Current code does (A), this has a problem when (B).
> >> >> >     We can improve this doing (C), because (D)."
> >> >>
> >> >> A is explained, B is empty, C is explained, D is because it makes sense.
> >
> > So one problem with your changelog is that you describe the change but
> > don't explain a couple of things - for example why you changed '3600' to
> > '1000'.
> 
> Yes, I am aware of that, and it probably should, but that has nothing
> to do with (A)(B)(C) or (D).

So you knew that your changelog was defective, but you elected to 
interpret reviewer feedback narrowly and chose to be intentionally
obtuse and difficult to waste even more reviewer time?

That's rather destructive behavior, which you further demonstrate
in the rest of your reply:

> >> > NAKed-by: Ingo Molnar <mingo@kernel.org>
> >>
> >> Suit yourself, stay with your buggy code then.
> >
> > I NAK-ed your patch because your patch has several technical problems.
> 
> No, this is why you NAK-ed the patch:

I very much know why I NAK-ed your patch.

> > > A is explained, B is empty, C is explained, D is because it makes 
> > > sense.
> >
> > NAKed-by: Ingo Molnar <mingo@kernel.org>
> 
> That is not a technical problem, that's an allegedly administrative one. 
> I said I would fix the technical issues.

You are mistaken: kernel changelogs are part of the change, a problem with 
a changelog is generally considered a technical problem as well.

> > To lift the NAK you'll need to address my review feedback 
> > constructively.
> 
> That's exactly what I did. Addressing feedback constructively doesn't 
> mean do exactly what you say without arguing.

Your reply to my routine feedback was obtuse, argumentative and needlessly 
confrontative - that's not 'constructive'.

> I will resend the patches separately since you are focusing on the 
> irrelevant patches and not paying attention to the one I made clear was 
> the important one, muddying it. [...]

That first patch is faulty as well.

Thanks,

	Ingo
