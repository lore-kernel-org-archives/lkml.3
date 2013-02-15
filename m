Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3BORAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:00:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3BORAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:00:21 -0500
Date: Fri, 15 Feb 2013 18:00:18 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH] printk: Remove separate printk_sched buffers and
 use printk buf instead
Message-ID: <20130215170018.GG7458@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
 <20130206230220.GA18329@quack.suse.cz>
 <20130212122245.GB19583@quack.suse.cz>
 <1360867691.23152.48.camel@gandalf.local.home>
 <20130215165032.GF7458@quack.suse.cz>
 <1360947217.23152.112.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360947217.23152.112.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-02-13 11:53:37, Steven Rostedt wrote:
> On Fri, 2013-02-15 at 17:50 +0100, Jan Kara wrote:
> > On Thu 14-02-13 13:48:11, Steven Rostedt wrote:
> > > On Tue, 2013-02-12 at 13:22 +0100, Jan Kara wrote:
> > > 
> > > > > Anyway, what do you guys think about this version?
> > > >   Steven, Andrew, did you have a chance to look at my patches?
> > > 
> > > Can you resend without being attachments. Patches sent as attachments
> > > seldom get reviewed.
> >   Well, for example I do review text/plain attachments but that may count
> > into 'seldom' ;) I'll send them inline.
> > 
> 
> The problem is that it makes it difficult to reply with comments. I
> haven't looked at the patches yet so I may not have comments, but on my
> email client, commenting attachments means that I need to cut and paste
> the text to do the comment, which isn't the case for inline patches.
  Yeah, I understand. I use mutt and it automatically includes text/plain
attachments into reply for me so I barely notice a difference between
inline and attached patch. But with other clients it may be a hassle...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
