Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3KKP7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:59:47 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46129 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:59:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131111153206.GA22113@thunk.org>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
	<1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
	<20131111113218.GF15810@gmail.com>
	<CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
	<20131111124953.GA6765@gmail.com>
	<CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
	<20131111132812.GB7258@gmail.com>
	<CAMP44s2NYKfrYngTEN5+mPPHOJZLNmSVd3n8k5QNv_=Lpvncsw@mail.gmail.com>
	<20131111135216.GB8781@gmail.com>
	<20131111153206.GA22113@thunk.org>
Date: Mon, 11 Nov 2013 09:59:28 -0600
Message-ID: <CAMP44s0qsjc_hHedYGt9tB=v8_UArM4N+vnwNybZ39vaoRXytA@mail.gmail.com>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 9:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Nov 11, 2013 at 02:52:16PM +0100, Ingo Molnar wrote:
>> > That's exactly what I did. Addressing feedback constructively doesn't
>> > mean do exactly what you say without arguing.
>>
>> Your reply to my routine feedback was obtuse, argumentative and needlessly
>> confrontative - that's not 'constructive'.
>
> Felipe, remember when on the Git list Junio said he would stop trying
> to respond to any patches that had problems because you couldn't
> respond constructively to feedback, and you claimed that you had no
> problems working with other folks, including on the Linux Kernel
> mailing list?

Ingo Molnar != kernel folks, and I don't see any hints of kernel folks
suggesting to drop patch #1 because of non-technical issues.

If the patch is technically correct, conforms to standard practices,
and solves a problem; it gets applied. Isn't that how it works in
Linux?

-- 
Felipe Contreras
