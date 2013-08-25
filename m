Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3HYSBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab3HYSBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:01:23 -0400
Date: Sun, 25 Aug 2013 19:55:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Spengler <spender@grsecurity.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] anon_inodefs: forbid open via /proc
Message-ID: <20130825175502.GA31703@redhat.com>
References: <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130825051044.GY27005@ZenIV.linux.org.uk> <20130825155348.GB25922@redhat.com> <CALCETrXrtP2C+g=QeNWK4EMctmonW91kWoO1xmy7rDmEj__1Dw@mail.gmail.com> <20130825174936.GA30957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825174936.GA30957@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Oleg Nesterov wrote:
>
> > I find it hard to believe that anything actually relies on open(2)
> > succeeding, given that it returns an fd with the wrong f_ops.
>
> OK, let me send the patch then. I won't argue if it is ignored or
> nacked.

Damn. Sorry for noise, I removed lkml by accident, let me resend.

Oleg.

