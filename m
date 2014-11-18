Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaKRDAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:00:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10562 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751213AbaKRDAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:00:04 -0500
Date: Mon, 17 Nov 2014 22:00:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
Message-ID: <20141117220000.502eeb1c@gandalf.local.home>
In-Reply-To: <1416279052.6651.1.camel@perches.com>
References: <20141115045847.712848224@goodmis.org>
	<20141115050604.073390701@goodmis.org>
	<20141117123642.1de9252e@gandalf.local.home>
	<1416269253.29010.4.camel@perches.com>
	<20141117192733.0ab1ba2e@gandalf.local.home>
	<1416270932.29010.6.camel@perches.com>
	<20141117195651.27c79369@gandalf.local.home>
	<1416272878.29010.8.camel@perches.com>
	<20141117202432.0376417f@gandalf.local.home>
	<1416275317.29010.10.camel@perches.com>
	<20141117213755.09285299@gandalf.local.home>
	<1416279052.6651.1.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 18:50:52 -0800
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-11-17 at 21:37 -0500, Steven Rostedt wrote:
> > On Mon, 17 Nov 2014 17:48:37 -0800
> > Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2014-11-17 at 20:24 -0500, Steven Rostedt wrote:
> > > > On Mon, 17 Nov 2014 17:07:58 -0800
> > > > Joe Perches <joe@perches.com> wrote:
> > > > > > Look at the next patch.
> > > > > I don't have it and you are not cc'ing me.
> > > > It's on LKML.
> > > 
> > > And?  There's no convenient way to retrieve it.
> > 
> > You're not subscribed?
> 
> I am subscribed and I delete stuff, don't you?

Nope, I keep all LKML messages. I have archives since 2005.

> 
> > > > Um, that may be the case for seq_file, but it is not the case for
> > > > trace_seq. seq_buf is influenced by seq_file because I have a patch to
> > > > make seq_file use it, but it's also the guts of trace_seq that has some
> > > > different requirements. And it's also not the case with the users of
> > > > seq_buf in the last patch.
> > > 
> > > I think your patch subject description needs expanding.
> > > It says seq_buf, nothing about trace.
> > 
> > It doesn't need to. This helps out the code. seq_buf has nothing to do
> > with seq_file (yet).
> 
> No, I don't think it does help seq_buf.  It only helps trace.

What are you talking about? seq_buf did not exist until this patch set.

> 
> btw:
> 
> I think you should cc Al Viro on the entire patch set.
> 

Why? Currently this is only tracing code. There's nothing in here that
has anything to do with VFS.

When I post patches to convert seq_file to use seq_buf, then I'll Cc Al.

-- Steve

