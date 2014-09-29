Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaI2XsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:48:20 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:52381 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751176AbaI2XsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:48:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3871:3873:3874:4321:5007:7652:8603:10004:10400:10848:10967:11026:11232:11658:11914:12517:12519:12740:13069:13076:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes73_483c7fe7b5e49
X-Filterd-Recvd-Size: 1749
Message-ID: <1412034495.4302.64.camel@joe-AO725>
Subject: Re: [PATCH 1/7] seq_file: Rename static bool seq_overflow to public
 bool seq_is_full
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 29 Sep 2014 16:48:15 -0700
In-Reply-To: <20140929194407.26832810@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <848ac7e3d1c31cddf638a8526fa3c59fa6fdeb8a.1412031505.git.joe@perches.com>
	 <20140929194407.26832810@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 19:44 -0400, Steven Rostedt wrote:
> On Mon, 29 Sep 2014 16:08:21 -0700 Joe Perches <joe@perches.com> wrote:
> > The return values of seq_printf/puts/putc are frequently misused.
> > 
> > Start down a path to remove all the return value uses of these
> > functions.
[]
> Actually, can you make a separate function that's public that is
> seq_is_full(), where m->count >= m->size, and leave seq_overflow()
> alone.

Change the first patch to suit your taste.

The rest of the series should not need change.

