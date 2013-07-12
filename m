Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372Ab3GLUT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965283Ab3GLUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:19:56 -0400
Date: Fri, 12 Jul 2013 16:19:39 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712201939.GB15261@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, Theodore Ts'o <tytso@mit.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712181103.GA6689@roeck-us.net>
 <20130712193557.GB342@thunk.org>
 <1373658551.17876.117.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373658551.17876.117.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Like most of the other examples in this thread, one size doesn't fit all though.

Your example above: If that fix was for "tracing reports wrong results", no big deal,
everyone can live with it for a month. If it was fixing "a bug in tracing can allow
an unprivileged user to crash the kernel", a month is unacceptable, and at
the least we should be getting an interim fix to mitigate the problem.

	Dave

