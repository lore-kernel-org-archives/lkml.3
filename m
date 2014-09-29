Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaI2QIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:08:07 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:45043 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754752AbaI2QIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:08:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3291:3351:3622:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6691:7652:7903:8985:9025:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hen12_807a899dd590e
X-Filterd-Recvd-Size: 1551
Message-ID: <1412006881.4302.29.camel@joe-AO725>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Sep 2014 09:08:01 -0700
In-Reply-To: <20140929154711.GF7996@ZenIV.linux.org.uk>
References: <20140926143721.52206f95@gandalf.local.home>
	 <20140929144121.GA30562@pathway.suse.cz>
	 <20140929154711.GF7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 16:47 +0100, Al Viro wrote:
> On Mon, Sep 29, 2014 at 04:41:22PM +0200, Petr Mladek wrote:
> > Hmm, this inconsistency seems to be in more functions. I would divide
> > it into three categories:
[]
> No.  _Any_ caller that decides to report that error to its caller is fucking
> broken.  We had some cases like that.
[]
> And let's make seq_printf and friends return void.  Any breakage we miss
> on grep will be caught by compiler.  Enough is enough.

https://lkml.org/lkml/2013/12/11/8


