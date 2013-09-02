Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3IBVvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:51:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54372 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758976Ab3IBVvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:51:05 -0400
Message-ID: <1378158663.1953.123.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Add warning about submitting patches using
 --file
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 02 Sep 2013 14:51:03 -0700
In-Reply-To: <20130902203705.GN19256@mwanda>
References: <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <1378150847.1953.106.camel@joe-AO722>
	 <20130902203705.GN19256@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 23:37 +0300, Dan Carpenter wrote:
> On Mon, Sep 02, 2013 at 12:40:47PM -0700, Joe Perches wrote:
> > +WARNING: When using --file mode, do not send patches that just make
> > +whitespace or formatting changes unless more significant changes are
> > +also made for other reasons in another patch.
> > +
> 
> This is a run on sentence.

Suggest alternatives.
I suppose "are also made" could be shortened.

> Also I don't agree with it.  Clean up
> patches are good on their own.

Try getting one past James "stasis" Bottomley.

> There are parts of the kernel which are
> not just in staging where I refuse to look at because it is so bad.

Me too.

> The problem is that people send "clean up" patches which don't clean up
> the code or which make the code worse than the original.

Maybe the only way to learn coding taste is to have
patches rejected.

> All they care
> about is pleasing checkpatch.pl instead of actually thinking about what
> they are doing.  The message should just say something like, "Take a
> step back and think about if this actually improves things for human
> readers."

Maybe.  Suggest better text.


