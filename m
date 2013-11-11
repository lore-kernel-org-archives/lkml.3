Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3KKNol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:44:41 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:62648 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3KKNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131111132812.GB7258@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
	<1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
	<20131111113218.GF15810@gmail.com>
	<CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
	<20131111124953.GA6765@gmail.com>
	<CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
	<20131111132812.GB7258@gmail.com>
Date: Mon, 11 Nov 2013 07:43:59 -0600
Message-ID: <CAMP44s2NYKfrYngTEN5+mPPHOJZLNmSVd3n8k5QNv_=Lpvncsw@mail.gmail.com>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 7:28 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> On Mon, Nov 11, 2013 at 6:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>> >
>> >> On Mon, Nov 11, 2013 at 5:32 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >> >
>> >> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>> >> >
>> >> >> We want to calculate the blinks per second, and instead of making it 5
>> >> >> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
>> >> >> per second.
>> >> >
>> >> > Please use the customary changelog style we use in the kernel:
>> >> >
>> >> >   " Current code does (A), this has a problem when (B).
>> >> >     We can improve this doing (C), because (D)."
>> >>
>> >> A is explained, B is empty, C is explained, D is because it makes sense.
>
> So one problem with your changelog is that you describe the change but
> don't explain a couple of things - for example why you changed '3600' to
> '1000'.

Yes, I am aware of that, and it probably should, but that has nothing
to do with (A)(B)(C) or (D).

>> > NAKed-by: Ingo Molnar <mingo@kernel.org>
>>
>> Suit yourself, stay with your buggy code then.
>
> I NAK-ed your patch because your patch has several technical problems.

No, this is why you NAK-ed the patch:

> > A is explained, B is empty, C is explained, D is because it makes sense.
>
> NAKed-by: Ingo Molnar <mingo@kernel.org>

That is not a technical problem, that's an allegedly administrative
one. I said I would fix the technical issues.

> To lift the NAK you'll need to address my review feedback constructively.

That's exactly what I did. Addressing feedback constructively doesn't
mean do exactly what you say without arguing.

I will resend the patches separately since you are focusing on the
irrelevant patches and not paying attention to the one I made clear
was the important one, muddying it. I will address the technical and
administrative issues in the 2nd and 3rd patches in the way I think is
best.

-- 
Felipe Contreras
