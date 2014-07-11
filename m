Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaGKQV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:21:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:41838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaGKQV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:21:58 -0400
Date: Fri, 11 Jul 2014 18:21:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jbaron@akamai.com
Subject: Re: [PATCH] Remove soon to be dead email address
Message-ID: <20140711162153.GV20603@laptop.programming.kicks-ass.net>
References: <20140711161341.GF12054@laptop.lan>
 <CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:17:31PM +0200, Geert Uytterhoeven wrote:
> On Fri, Jul 11, 2014 at 6:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > My Red Hat email address will soon cease to be; remove it from the
> > tree in order to save the interweb some bounces.
> 
> > --- a/include/linux/jump_label.h
> > +++ b/include/linux/jump_label.h
> > @@ -4,8 +4,8 @@
> >  /*
> >   * Jump label support
> >   *
> > - * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
> > - * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
> > + * Copyright (C) 2009-2012 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
> 
> Change not mentioned in comment (there are a few more of these).
> 
> > + * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra

Oh, right.. my bad. I should also have Cc'ed Jason I suppose.

The thing is, those were copyright RedHat (implicitly by the @redhat and
my copyright assingment to employer at the time etc..) But if I remove
the email address there is nothing that reflects that.

The same is true for Jason, but let me copy him.
