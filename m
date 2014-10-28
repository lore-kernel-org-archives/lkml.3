Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaJ1PZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:25:56 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:59331 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925AbaJ1PZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:25:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3871:3872:3874:4321:5007:6261:10004:10400:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast08_8aa8a08953e20
X-Filterd-Recvd-Size: 1664
Message-ID: <1414509951.6643.8.camel@perches.com>
Subject: Re: [PATCH 6/7] debugfs: Fix misuse of seq_printf return value
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Oct 2014 08:25:51 -0700
In-Reply-To: <20141028105831.69a14d4d@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
	 <20141028105831.69a14d4d@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 10:58 -0400, Steven Rostedt wrote:
> On Mon, 29 Sep 2014 16:08:26 -0700
> Joe Perches <joe@perches.com> wrote:
> > Adding repeated -1 to the return is not correct.
> > Use seq_is_full to test for unnecessary seq_printf uses
> > and always return 0.
[]
> Actually, debugfs_print_regs32() should return void as well.
> I'll update that.

Great though this should possibly be another patch.

I didn't want to update the documentation.

Maybe remove the prototype and make it static too.


