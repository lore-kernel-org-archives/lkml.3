Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaKRAHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:07:39 -0500
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:56149 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752709AbaKRAHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:07:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3871:3874:4321:5007:6119:6261:7576:8603:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dust52_251090ffd5416
X-Filterd-Recvd-Size: 1533
Message-ID: <1416269253.29010.4.camel@perches.com>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Date: Mon, 17 Nov 2014 16:07:33 -0800
In-Reply-To: <20141117123642.1de9252e@gandalf.local.home>
References: <20141115045847.712848224@goodmis.org>
	 <20141115050604.073390701@goodmis.org>
	 <20141117123642.1de9252e@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 12:36 -0500, Steven Rostedt wrote:
> On Fri, 14 Nov 2014 23:59:07 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Add a seq_buf_can_fit() helper function that removes the possible mistakes
> > of comparing the seq_buf length plus added data compared to the size of
> > the buffer.
[]
> > +static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
> > +{
> > +	return s->len + len < s->size;
> > +}
> > +

Why is this useful?

