Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaJ0UZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:25:26 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:36720 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaJ0UZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:25:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3868:4321:5007:6119:6261:7903:10007:10400:10848:11026:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: lake13_4bff5dd5dba54
X-Filterd-Recvd-Size: 1513
Message-ID: <1414441520.18896.12.camel@perches.com>
Subject: Re: [PATCH 3/7] dlm: Use seq_is_full - remove seq_printf returns
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 13:25:20 -0700
In-Reply-To: <20141027161724.0ec20325@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <43590057bcb83846acbbcc1fe641f792b2fb7773.1412031505.git.joe@perches.com>
	 <20140930103435.GC2707@dhcp128.suse.cz>
	 <20141027161724.0ec20325@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 16:17 -0400, Steven Rostedt wrote:
> Note, I've started with Joe's patches and I'm massaging them for
> something I can work with.
[]
> I'm thinking of switching everything to use seq_has_overflowed() and
> try again.

Fine by me.


