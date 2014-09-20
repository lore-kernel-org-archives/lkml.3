Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaITQKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:10:54 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:52567 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750963AbaITQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:10:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plane49_41a56acff394c
X-Filterd-Recvd-Size: 1821
Message-ID: <1411229447.24444.53.camel@joe-AO725>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 20 Sep 2014 09:10:47 -0700
In-Reply-To: <20140920154733.GM2832@worktop.localdomain>
References: <20140916203510.GF1205@quack.suse.cz>
	 <20140916170709.73ef2993@gandalf.local.home>
	 <20140916212250.GI1205@quack.suse.cz>
	 <20140916173328.6306a5c2@gandalf.local.home>
	 <20140917141816.GO2840@worktop.localdomain>
	 <20140917102255.5cd03071@gandalf.local.home>
	 <20140917223633.GE2848@worktop.localdomain>
	 <20140917203135.6db2ee5e@gandalf.local.home>
	 <20140918173414.GU2840@worktop.localdomain>
	 <20140920051224.GA5573@quack.suse.cz>
	 <20140920154733.GM2832@worktop.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-20 at 17:47 +0200, Peter Zijlstra wrote:
> On a whole, printk() is entirely useless for debugging these days, its
> far too fragile/unreliable to be taken seriously so I really don't care
> on that point either.

That's unfortunate.

Care to enumerate the issues that you believe make
printk too fragile/unreliable for debugging?

