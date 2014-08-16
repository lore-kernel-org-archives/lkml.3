Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHPBqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 21:46:36 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35860 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaHPBqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 21:46:35 -0400
Date: Fri, 15 Aug 2014 21:46:34 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] aio: use iovec array rather than the single one
Message-ID: <20140816014634.GA27088@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org> <00fefb9cf2b5493a86912de55ba912bdfae4a207.1408122224.git.bcrl@kvack.org> <CA+55aFyYt41jie6N1UyawPYYnpRAMKcRG8wRTa_ShPreT24qTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyYt41jie6N1UyawPYYnpRAMKcRG8wRTa_ShPreT24qTw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 06:35:25PM -0600, Linus Torvalds wrote:
> Ben,
> 
> *please* stop doing this kind of crap.
> 
> You're creating fake emails with invalid senders. That's simply not acceptable.
...

I'll admit this was my mistake and I should have caught it while reviewing 
the emails.  At least in the past my mail client has generated the correct 
From: headers, but I made a mistake somewhere in the process today.  Evidently 
passing in the --from= parameter to git-format-patch has been missing from 
my scripts forever.

That said: git should *not* default to generating fake From: headers in 
generated emails!  Having the git default being completely unreasonable in 
this case makes absolutely no sense to me, especially when git already 
knows what my bloody email address is!  It's wrong, it's clear that it's 
wrong, so why is the default that way?

Damned rope shooting my foot off.  Please excuse me while I go find a medic 
to stop the bleeding...

		-ben
-- 
"Thought is the essence of where you are now."
