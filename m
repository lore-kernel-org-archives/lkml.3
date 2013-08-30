Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3H3Rdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:33:50 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33133 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3H3Rdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:33:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzYrCbJ78XVKk7Apkxa+F-gpE911zTpMnSoGsn4S+CdpA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<20130830171707.GV31370@twins.programming.kicks-ass.net>
	<CA+55aFzYrCbJ78XVKk7Apkxa+F-gpE911zTpMnSoGsn4S+CdpA@mail.gmail.com>
Date: Fri, 30 Aug 2013 10:33:48 -0700
X-Google-Sender-Auth: VQXObKVj_5zjmtyvjn5M7R5IwK8
Message-ID: <CA+55aFyffg5wk5gS-xEZz093uQL3Uveo_3ZV+k0RL76agNDNcA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've got a 4770S on order, it should arrive tomorrow. It's the 65W
> part, and it has TSX. But no, I doubt I'll see any real scalability
> issues with it, but at least I can test any TSX codepaths.

Side note: whatever marketing person inside Intel that decided that
the "K" parts shouldn't get TSX-NI support should be fired. Or at
least have a stern talking to (and by "stern" I obviously mean that
thumbscrews and hot pins under their nails should be involved).

If I wanted to build a peak performance machine (rather than a silent
one), I wouldn't have had TSX. What the hell is wrong with Intel
marketing? Their "lets fragment things" crap is making it harder to
actually support their new technologies.

                Linus
