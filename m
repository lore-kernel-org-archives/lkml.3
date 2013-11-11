Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3KKN2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:28:24 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:61893 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3KKN2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:28:15 -0500
Date: Mon, 11 Nov 2013 14:28:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
Message-ID: <20131111132812.GB7258@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
 <20131111113218.GF15810@gmail.com>
 <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
 <20131111124953.GA6765@gmail.com>
 <CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Mon, Nov 11, 2013 at 6:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >
> >> On Mon, Nov 11, 2013 at 5:32 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >
> >> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >> >
> >> >> We want to calculate the blinks per second, and instead of making it 5
> >> >> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
> >> >> per second.
> >> >
> >> > Please use the customary changelog style we use in the kernel:
> >> >
> >> >   " Current code does (A), this has a problem when (B).
> >> >     We can improve this doing (C), because (D)."
> >>
> >> A is explained, B is empty, C is explained, D is because it makes sense.

So one problem with your changelog is that you describe the change but 
don't explain a couple of things - for example why you changed '3600' to 
'1000'.

I know why you did it because I've read the diff and the related code, but 
such kind of information is best put into changelogs.

This is standard review feedback.

> >
> > NAKed-by: Ingo Molnar <mingo@kernel.org>
> 
> Suit yourself, stay with your buggy code then.

I NAK-ed your patch because your patch has several technical problems. To 
lift the NAK you'll need to address my review feedback constructively.

Thanks,

	Ingo
