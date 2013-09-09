Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab3IIA5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:57:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49144 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3IIA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:57:43 -0400
Date: Mon, 9 Sep 2013 01:57:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130909005733.GL13318@ZenIV.linux.org.uk>
References: <1377751465.4028.20.camel@pasglop>
 <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
 <20130909000300.GH13318@ZenIV.linux.org.uk>
 <CA+55aFy6=CvNet+fjcYiFxbb_E1gDPzudaJ+hVotYuG5zuMb5Q@mail.gmail.com>
 <20130909003517.GJ13318@ZenIV.linux.org.uk>
 <CA+55aFwEs6epLkbp2L9+7jR9+AWB=fsB+dJMUeufxvPDF9hBgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwEs6epLkbp2L9+7jR9+AWB=fsB+dJMUeufxvPDF9hBgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 05:38:46PM -0700, Linus Torvalds wrote:
> On Sun, Sep 8, 2013 at 5:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > That should also work, replacing the current tip of #for-next.  Do you
> > prefer to merge those two diffs of yours into a single commit?
> 
> If you're ok with my patch (it's now also tested, I'm running with it
> and it looks fine), I'll commit that one as-is.

OK...  I'm dropping 38373e1ee72bf57b6f9b1ab0979a60887352c7e6, then...
