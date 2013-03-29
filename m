Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3C2SrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:47:11 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:39043 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3C2SrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130329182411.GD2567@kernel.dk>
References: <20130329153831.GQ19488@kernel.dk>
	<CA+55aFwoj=g0YrFOrpoKNY43o8qDAhDEHSP-zrtpWCXciwz_-Q@mail.gmail.com>
	<20130329182411.GD2567@kernel.dk>
Date: Fri, 29 Mar 2013 11:47:07 -0700
X-Google-Sender-Auth: RjRAU9i3o4mS_o088AlUaKt_dZQ
Message-ID: <CA+55aFwWFma7qK3v7QtxRqp=GHnON8DF0kO84yDvsxu3nkb-xA@mail.gmail.com>
Subject: Re: [GIT PULL] block fixes for 3.9-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:24 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
>> Don't do this kind of thing. That branch is pointless, and just
>> confused you.
>
> Tag, you mean?

No. Branch. Why would you have a public branch called "for-linus",
when you intend to tag the end result before sending it to me?

It would make much more sense if you just did your development in your
"master" branch, perhaps with a separate branch for fixes during
stabilization (so that you don't mix up fixes with your future
development. Call it "fixes" or "stable" or whatever. No "for-linus"
branches anywhere. After all, the branch isn't for me at all. It's for
me only once you're ready. And at that point you tag it, so having a
*tag* called for-linus makes sense and gives us the nice signing etc.

Hmm?

            Linus
