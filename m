Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaDAD2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:28:05 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53039 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaDAD2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:28:04 -0400
Message-ID: <1396322880.5324.37.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 01 Apr 2014 05:28:00 +0200
In-Reply-To: <CA+55aFwdosGtoh8=krpx9C-fT-H7OHsC0UVyXc8aNE7h=W1RxQ@mail.gmail.com>
References: <1396164244.28950.15.camel@marge.simpson.net>
	 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	 <1396239636.5361.57.camel@marge.simpson.net>
	 <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
	 <1396290426.5261.80.camel@marge.simpson.net>
	 <CA+55aFwdosGtoh8=krpx9C-fT-H7OHsC0UVyXc8aNE7h=W1RxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 11:37 -0700, Linus Torvalds wrote: 
> On Mon, Mar 31, 2014 at 11:27 AM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:
> >
> > Oh, I didn't cc you because I wanted it applied instantly as ultra
> > critical, only because the chain of events might be of interest.
> 
> Ok. That was my main worry, since I was in the process or releasing
> 3.14, and I just couldn't tell if the patch was something I should
> worry about or not.
> 
> And it seems that not applying it was the right thing, which is all
> that matters by now.

Yes.  Jocular red flag was to Peter and Ingo.  I don't try to bypass
them, that would be plain rude.  I've been known to help maintainers a
little, but I don't ever try to call the shots.  They do that well.

-Mike

