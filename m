Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaKRCu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:50:57 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:58990 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752045AbaKRCu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:50:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2840:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:7903:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12663:12679:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: juice96_7c97fd5d7337
X-Filterd-Recvd-Size: 2571
Message-ID: <1416279052.6651.1.camel@perches.com>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Date: Mon, 17 Nov 2014 18:50:52 -0800
In-Reply-To: <20141117213755.09285299@gandalf.local.home>
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
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 21:37 -0500, Steven Rostedt wrote:
> On Mon, 17 Nov 2014 17:48:37 -0800
> Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-11-17 at 20:24 -0500, Steven Rostedt wrote:
> > > On Mon, 17 Nov 2014 17:07:58 -0800
> > > Joe Perches <joe@perches.com> wrote:
> > > > > Look at the next patch.
> > > > I don't have it and you are not cc'ing me.
> > > It's on LKML.
> > 
> > And?  There's no convenient way to retrieve it.
> 
> You're not subscribed?

I am subscribed and I delete stuff, don't you?

> > > Um, that may be the case for seq_file, but it is not the case for
> > > trace_seq. seq_buf is influenced by seq_file because I have a patch to
> > > make seq_file use it, but it's also the guts of trace_seq that has some
> > > different requirements. And it's also not the case with the users of
> > > seq_buf in the last patch.
> > 
> > I think your patch subject description needs expanding.
> > It says seq_buf, nothing about trace.
> 
> It doesn't need to. This helps out the code. seq_buf has nothing to do
> with seq_file (yet).

No, I don't think it does help seq_buf.  It only helps trace.

btw:

I think you should cc Al Viro on the entire patch set.


