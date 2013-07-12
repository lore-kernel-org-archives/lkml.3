Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3GLTz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:55:27 -0400
Received: from 1wt.eu ([62.212.114.60]:34557 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3GLTz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:55:26 -0400
Date: Fri, 12 Jul 2013 21:55:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712195501.GC32054@1wt.eu>
References: <20130711214830.611455274@linuxfoundation.org> <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com> <20130712141530.GA3629@roeck-us.net> <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com> <20130712173150.GA5534@roeck-us.net> <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com> <20130712181103.GA6689@roeck-us.net> <20130712193557.GB342@thunk.org> <1373658551.17876.117.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373658551.17876.117.camel@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 03:49:11PM -0400, Steven Rostedt wrote:
> On Fri, 2013-07-12 at 15:35 -0400, Theodore Ts'o wrote:
> 
> > So the problem is that maintainers are lazy.  They don't want to go
> > back for bug fixes that have "proven" themselves, and even if they
> > aren't critical bug fixes, they are things which a distro maintainer
> > or a stable kernel user might want (and sometimes stable uers are
> > uppity enough to expect subsystem maintainers to do this back
> > porting).  So subsystem maintainers then react by marking submits for
> > stable even though they really should soak for a release or two before
> > submitting them, since by marking them as submit, the commit gets
> > pushed to stable automatically --- albeit early.
> 
> Actually, this is a very good point. There were one or two stable
> patches I had pushed to linux-next that I wasn't too comfortable about.
> If the fix goes back to older trees, I rather have them stirring in
> linux-next and push it in the next merge window instead of pushing it to
> Linus and have it go to stable immediately.
> 
> Unless its a obvious fix, I tend to take about a month from the time I
> get a stable fix to the time I push it out. Making sure the stable fix
> doesn't introduce new bugs.

Indeed, which goes down to my comment somewhere else in this thread about
"Cc:stable" being used as a convenient marker for a bug fix. Let's simply
have a real marker and this should flow much smoother because end users
will ask "Dear stable maintainers, could we please merge this patch, I
need it".

Regards,
Willy

