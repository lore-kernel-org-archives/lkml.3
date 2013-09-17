Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3IQVdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:33:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3IQVdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:33:13 -0400
Date: Tue, 17 Sep 2013 14:33:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Add warning about submitting patches using
 --file
Message-Id: <20130917143312.0ca010002b7196a1f0868cad@linux-foundation.org>
In-Reply-To: <20130902203705.GN19256@mwanda>
References: <9976.1378132260@warthog.procyon.org.uk>
	<1378138205.1953.66.camel@joe-AO722>
	<20130902181510.GA29787@leaf>
	<20130902181856.GB29787@leaf>
	<1378150847.1953.106.camel@joe-AO722>
	<20130902203705.GN19256@mwanda>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013 23:37:05 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Mon, Sep 02, 2013 at 12:40:47PM -0700, Joe Perches wrote:
> > +WARNING: When using --file mode, do not send patches that just make
> > +whitespace or formatting changes unless more significant changes are
> > +also made for other reasons in another patch.
> > +
> 
> This is a run on sentence.  Also I don't agree with it.  Clean up
> patches are good on their own.  There are parts of the kernel which are
> not just in staging where I refuse to look at because it is so bad.
> 
> The problem is that people send "clean up" patches which don't clean up
> the code or which make the code worse than the original.  All they care
> about is pleasing checkpatch.pl instead of actually thinking about what
> they are doing.  The message should just say something like, "Take a
> step back and think about if this actually improves things for human
> readers."

I don't agree either, really.  If someone sends a large cleanup patch
and it improves the code and comes at a suitable time, I'll happily
apply it, because it makes the kernel better.

Often these patches come from newbies and they've made various errors,
the most common of which is missed opportunities: there are cleanups
which should have been made but which weren't, due to timidity or to
lack of experience.  And that's OK - you point these things out, work
with the submitter and end up with a good patch and a happy and
better-informed submitter and a better kernel.  What's not to like
about that?

Sure, it takes time and it takes work.  But that's the maintainer's
problem, nobody else's.  Don't go assuming that your problems and
priorities are universal ones!

