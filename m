Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3C2T53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:57:29 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53592 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab3C2T52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130329190017.GE2567@kernel.dk>
References: <20130329153831.GQ19488@kernel.dk>
	<CA+55aFwoj=g0YrFOrpoKNY43o8qDAhDEHSP-zrtpWCXciwz_-Q@mail.gmail.com>
	<20130329182411.GD2567@kernel.dk>
	<CA+55aFwWFma7qK3v7QtxRqp=GHnON8DF0kO84yDvsxu3nkb-xA@mail.gmail.com>
	<20130329190017.GE2567@kernel.dk>
Date: Fri, 29 Mar 2013 12:57:26 -0700
X-Google-Sender-Auth: lhwLnYT05pVGegFRCSJgETpoNFA
Message-ID: <CA+55aFz8qeasecRz9SP2BaidzQfL89DD-MBU04k+dc1yraTonQ@mail.gmail.com>
Subject: Re: [GIT PULL] block fixes for 3.9-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 12:00 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Outside of "that's what I have always done", the intent was for others
> that send patches through me to know what to base it off, if not
> previous release. All those folks know that for-3.x/drivers is for the
> next x release, and that for-linus is for the existing tree.

Ok. Whatever. Feel free to continue doing it, but at least then make
sure that the pull message refers to "tags/for-linus" and not that
ambiguous "for-linus" thing.

Because you screwed up that pull request, and I argue that you screwed
up exactly *because* it's ambiguous and confusing.  The confusion may
have happened before too, but because git will silently default to the
branch for the ambiguous case, I just never noticed that I didn't
actually get the proper signature. Now I noticed, because you said it
was signed and yet my pull got the non-signed thing.

              Linus
