Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3CBDzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:55:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3CBDza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:55:30 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dCXt4Z_EDXgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VHl0eERhotoA:10 a=vuR0nV-uQgYmcsVhfi4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362196529.1231.80.camel@gandalf.local.home>
Subject: Re: linux-next: build failure after merge of the ftrace tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 22:55:29 -0500
In-Reply-To: <20130302144229.f41f56c36992497a1530d65f@canb.auug.org.au>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
	 <1362192318.1231.67.camel@gandalf.local.home>
	 <20130302144229.f41f56c36992497a1530d65f@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 14:42 +1100, Stephen Rothwell wrote:
> Hi Steve,
> 
> On Fri, 01 Mar 2013 21:45:18 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri, 2013-03-01 at 13:47 +1100, Stephen Rothwell wrote:
> > > 
> > > After merging the ftrace tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > > 
> > > kernel/trace/trace_kdb.c: In function 'ftrace_dump_buf':
> > > kernel/trace/trace_kdb.c:29:33: error: invalid type argument of '->' (have 'struct trace_array_cpu')
> > > kernel/trace/trace_kdb.c:86:33: error: invalid type argument of '->' (have 'struct trace_array_cpu')
> > > 
> > > Caused by commit eaac1836c10e ("tracing: Replace the static global
> > > per_cpu arrays with allocated per_cpu").
> > > 
> > > I have used the ftrace tree from next-20130228 for today.
> > 
> > I rebased, and it should all be good now. I also fixed breakage to the
> > new snapshot feature. Here's my diff:
> 
> Of course, I wonder if this is intended for the current merge window
> (since it turned up in linux-next so late).  If not, then please don;t
> put it in your -next included branch until after -rc1 is released.  If
> you are aiming for this merge window, then good luck!  ;-)
> 

Oh crap, sorry. Quite the contrary. I should have waited for -rc1 as
this is intended for v3.10.

I made some major changes and wanted testing on it as soon as possible.
I've done tons of testing on my own but I wanted a broader audience. Do
you want me to pull my tree and reset it to what is only for 3.9?

All changes I wanted for 3.9 have already made it into Linus's tree.
Everything I've been pushing is destined for 3.10. But as I said. They
are big changes and wanted testing on them early. But it can wait for an
-rc1 window.

-- Steve


