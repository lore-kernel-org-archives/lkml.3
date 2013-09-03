Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3ICPin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:38:43 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55920 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3ICPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:38:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUVqKBVgmOMviVDojR9i65SgrubdCWJVD1y_kUjtgYtQMw@mail.gmail.com>
References: <5220F090.5050908@hp.com>
	<20130830194059.GC13318@ZenIV.linux.org.uk>
	<5220F811.9060902@hp.com>
	<20130830202608.GD13318@ZenIV.linux.org.uk>
	<52210225.60805@hp.com>
	<20130830204852.GE13318@ZenIV.linux.org.uk>
	<52214EBC.90100@hp.com>
	<20130831023516.GI13318@ZenIV.linux.org.uk>
	<20130831024233.GJ13318@ZenIV.linux.org.uk>
	<5224E647.80303@hp.com>
	<20130903060130.GD16261@gmail.com>
	<CA+icZUVqKBVgmOMviVDojR9i65SgrubdCWJVD1y_kUjtgYtQMw@mail.gmail.com>
Date: Tue, 3 Sep 2013 08:38:40 -0700
X-Google-Sender-Auth: _D8IN9AnppAgBQ5dcctlS6WD2Xc
Message-ID: <CA+55aFwHk20Go1bZwwNpNXaLsQEV2DC4tsbfOp21ufz7VGq_VQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <waiman.long@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 12:24 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Can someone summarize this thread (70+ postings)?
> Which patches are needed? And fixing what?
> ( Can people provide separate patches with a proper changelog? )
> Improvements?

The core lockref part is now merged and available in my git tree (and
yes, as individual patches with proper logs).

Al's patch to avoid the lg_lock is still pending, I'm assuming I'll
get it through his VFS tree.

            Linus
