Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3KKMyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:54:18 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:34296 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3KKMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:54:05 -0500
MIME-Version: 1.0
In-Reply-To: <20131111124953.GA6765@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
	<1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
	<20131111113218.GF15810@gmail.com>
	<CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
	<20131111124953.GA6765@gmail.com>
Date: Mon, 11 Nov 2013 06:54:03 -0600
Message-ID: <CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
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

On Mon, Nov 11, 2013 at 6:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> On Mon, Nov 11, 2013 at 5:32 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>> >
>> >> We want to calculate the blinks per second, and instead of making it 5
>> >> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
>> >> per second.
>> >
>> > Please use the customary changelog style we use in the kernel:
>> >
>> >   " Current code does (A), this has a problem when (B).
>> >     We can improve this doing (C), because (D)."
>>
>> A is explained, B is empty, C is explained, D is because it makes sense.
>
> NAKed-by: Ingo Molnar <mingo@kernel.org>

Suit yourself, stay with your buggy code then.

Patch #1 is the important one anyway.

-- 
Felipe Contreras
