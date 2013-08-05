Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3HESYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:24:37 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:55154 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3HESYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:24:36 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
	<CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
Date: Mon, 5 Aug 2013 11:24:35 -0700
X-Google-Sender-Auth: ZOYQvl-LyQAKO2iOlZSccKGjCkY
Message-ID: <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 11:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The static_key_false() approach with minimal inlining sounds like a
> much better approach overall.

Sorry, I misunderstood your thing. That's actually what you want that
section thing for, because right now you cannot generate the argument
expansion otherwise.

Ugh. I can see the attraction of your section thing for that case, I
just get the feeling that we should be able to do better somehow.

                  Linus
