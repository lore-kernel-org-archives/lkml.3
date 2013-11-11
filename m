Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3KKMuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:50:05 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:33584 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3KKMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:49:57 -0500
Date: Mon, 11 Nov 2013 13:49:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
Message-ID: <20131111124953.GA6765@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
 <20131111113218.GF15810@gmail.com>
 <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Mon, Nov 11, 2013 at 5:32 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >
> >> We want to calculate the blinks per second, and instead of making it 5
> >> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
> >> per second.
> >
> > Please use the customary changelog style we use in the kernel:
> >
> >   " Current code does (A), this has a problem when (B).
> >     We can improve this doing (C), because (D)."
> 
> A is explained, B is empty, C is explained, D is because it makes sense.

NAKed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
