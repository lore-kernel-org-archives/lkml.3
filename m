Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaJ1Pvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:51:53 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:54414 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362AbaJ1Pvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:51:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3165:3622:3865:3866:3867:3868:3873:3874:4321:5007:6261:6742:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12663:12740:13019:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: laugh12_498d3fef11017
X-Filterd-Recvd-Size: 1682
Message-ID: <1414511499.6643.11.camel@perches.com>
Subject: Re: [PATCH 0/7] seq_printf cleanups
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 28 Oct 2014 08:51:39 -0700
In-Reply-To: <20141028113240.74dbe5c5@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <20141028113240.74dbe5c5@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 11:32 -0400, Steven Rostedt wrote:
> If you haven't already done so, can you update checkpatch.pl to
> complain if someone checks the return value of seq_printf(),
> seq_puts(), or seq_putc().

I'm not sure that matters much as a rule because I
hope soon the compiler will bleat when that happens.

There are several more too:

	seq_vprintf
	seq_escape
	seq_write
	seq_bitmap
	seq_cpumask/seq_nodemask (and _list variants),
	seq_put_decimal_xxx



