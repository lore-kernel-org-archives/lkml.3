Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3AWExj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:53:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:58138 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3AWExi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:53:38 -0500
Date: Tue, 22 Jan 2013 20:55:03 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
Message-ID: <20130123045503.GB3309@kroah.com>
References: <1358910114.21576.86.camel@gandalf.local.home>
 <20130123040846.GA2638@kroah.com>
 <1358915495.21576.102.camel@gandalf.local.home>
 <1358916249.21576.105.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358916249.21576.105.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:44:09PM -0500, Steven Rostedt wrote:
> On Tue, 2013-01-22 at 23:31 -0500, Steven Rostedt wrote:
> 
> > > 
> > > But again, I'd really not want to do this in debugfs, how about your own
> > > filesystem?
> > 
> > I will note that this never modifies the debugfs code. But it does
> > circumvent it. That is, all this code lives in kernel/trace/trace.c. I
> > don't modify any of the debugfs code. I just replace the debugfs
> > dentry->d_inode->i_op with my own ops.
> 
> Again, I want to stress that this doesn't touch the debugfs code. Here's
> the real change that I've been testing. It includes the code for the
> "new" and "free" files but those are not created because of an early
> 'return' I added. Notice that it's all contained in
> kernel/trace/trace.c.

Ok, then I'll just forget you ever asked anything about this and wish
you well :)

Have fun,

greg k-h
