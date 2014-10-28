Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaJ1RiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:38:09 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:45077 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752617AbaJ1RiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:38:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:6261:7903:7974:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12663:12740:13019:13069:13311:13357:13618:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cast82_806c353967257
X-Filterd-Recvd-Size: 2279
Message-ID: <1414517881.10912.2.camel@perches.com>
Subject: Re: [PATCH 7/7] docg3: Fix miuse of seq_printf return value
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Oct 2014 10:38:01 -0700
In-Reply-To: <20141028133253.223e47f7@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <c1a1138f1b05e87a3fbd8737af2f2c0be6e2724b.1412031505.git.joe@perches.com>
	 <20141022082916.GD16128@brian-ubuntu>
	 <20141028111301.22481f2a@gandalf.local.home>
	 <1414511877.6643.12.camel@perches.com>
	 <20141028120552.63c2324c@gandalf.local.home>
	 <1414517260.6643.21.camel@perches.com>
	 <20141028133253.223e47f7@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 13:32 -0400, Steven Rostedt wrote:
> On Tue, 28 Oct 2014 10:27:40 -0700 Joe Perches <joe@perches.com> wrote:
> > On Tue, 2014-10-28 at 12:05 -0400, Steven Rostedt wrote:
> > > I would like to get this done before I do my merge of trace_seq and
> > > seq_file, but I'm thinking I may have to do that in parallel.
> > 
> > I think the most important thing is to get the
> > seq_is_overflown (or seq_has_overflowed or whatever
> > other name is chosen) function added then the rest
> > of the patches can be applied whenever maintainers
> > (or Andrew or trivial or ...) pick them up.
> 
> I can get that in without much of an issue. But the merge of trace_seq
> and seq_file would be easier if I didn't have to worry about return
> values. Which is why I want to get this in quickly.

What is the issue there?



