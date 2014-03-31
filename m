Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaCaShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:37:10 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:35586 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaCaShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <1396290426.5261.80.camel@marge.simpson.net>
References: <1396164244.28950.15.camel@marge.simpson.net>
	<CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	<1396239636.5361.57.camel@marge.simpson.net>
	<CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
	<1396290426.5261.80.camel@marge.simpson.net>
Date: Mon, 31 Mar 2014 11:37:07 -0700
X-Google-Sender-Auth: Bh9ZkLWfuzyklT6pvwwfAmpX3ZA
Message-ID: <CA+55aFwdosGtoh8=krpx9C-fT-H7OHsC0UVyXc8aNE7h=W1RxQ@mail.gmail.com>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:27 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
>
> Oh, I didn't cc you because I wanted it applied instantly as ultra
> critical, only because the chain of events might be of interest.

Ok. That was my main worry, since I was in the process or releasing
3.14, and I just couldn't tell if the patch was something I should
worry about or not.

And it seems that not applying it was the right thing, which is all
that matters by now.

Thanks,
         Linus
