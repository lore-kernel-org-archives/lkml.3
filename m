Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaJ1P7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:59:45 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:55379 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbaJ1P7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:59:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3872:3873:3874:4321:4362:5007:6261:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stamp24_8edc677ec9221
X-Filterd-Recvd-Size: 1549
Message-ID: <1414511980.6643.14.camel@perches.com>
Subject: Re: [PATCH 6/7] debugfs: Fix misuse of seq_printf return value
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Oct 2014 08:59:40 -0700
In-Reply-To: <20141028114241.0bebcedd@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
	 <20141028105831.69a14d4d@gandalf.local.home>
	 <1414509951.6643.8.camel@perches.com>
	 <20141028114241.0bebcedd@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 11:42 -0400, Steven Rostedt wrote:
> On Tue, 28 Oct 2014 08:25:51 -0700 Joe Perches <joe@perches.com> wrote:
[]
> > Maybe remove the prototype and make it static too.
> Now that can be a separate patch set if you want.

No worries, it could happen later.
Thanks for taking this on btw.


