Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3AWFFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:05:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3AWFF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:05:28 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1lp5RE5RrrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CpGQe48J6BUA:10 a=E0_zZw1UMibW4EwDf90A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358917527.21576.112.camel@gandalf.local.home>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Jan 2013 00:05:27 -0500
In-Reply-To: <20130123045503.GB3309@kroah.com>
References: <1358910114.21576.86.camel@gandalf.local.home>
	 <20130123040846.GA2638@kroah.com>
	 <1358915495.21576.102.camel@gandalf.local.home>
	 <1358916249.21576.105.camel@gandalf.local.home>
	 <20130123045503.GB3309@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 20:55 -0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 22, 2013 at 11:44:09PM -0500, Steven Rostedt wrote:
> > On Tue, 2013-01-22 at 23:31 -0500, Steven Rostedt wrote:
> > 
> > > > 
> > > > But again, I'd really not want to do this in debugfs, how about your own
> > > > filesystem?
> > > 
> > > I will note that this never modifies the debugfs code. But it does
> > > circumvent it. That is, all this code lives in kernel/trace/trace.c. I
> > > don't modify any of the debugfs code. I just replace the debugfs
> > > dentry->d_inode->i_op with my own ops.
> > 
> > Again, I want to stress that this doesn't touch the debugfs code. Here's
> > the real change that I've been testing. It includes the code for the
> > "new" and "free" files but those are not created because of an early
> > 'return' I added. Notice that it's all contained in
> > kernel/trace/trace.c.
> 
> Ok, then I'll just forget you ever asked anything about this and wish
> you well :)
> 
> Have fun,

Don't leave me.... I'm afraid....


I only Cc'd you because it was interacting with debugfs, and was hoping
that you could shed any light that what I did may cause me issues in the
future.

But it's my problem not yours. It may bite me in the ass later, but for
now, it looks like it may work.

-- Steve


