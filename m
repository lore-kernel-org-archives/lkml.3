Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaI2Pq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:46:56 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:56489 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753656AbaI2Pqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:46:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7652:7903:8985:9025:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stop56_5917d6f65ff4e
X-Filterd-Recvd-Size: 1479
Message-ID: <1412005610.4302.26.camel@joe-AO725>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Sep 2014 08:46:50 -0700
In-Reply-To: <20140929112538.3929a9a2@gandalf.local.home>
References: <20140926143721.52206f95@gandalf.local.home>
	 <20140929144121.GA30562@pathway.suse.cz>
	 <20140929112538.3929a9a2@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 11:25 -0400, Steven Rostedt wrote:
> Anyway, that should be a second patch, and we should get my current
> patch (the one to make putc and puts the same) in first, as that
> actually fixes the inconsistency between the two.
> 
> I'll post another patch to try to make seq_file operations a bit more
> consistent. Perhaps we can have m->count be what would have been
> written.

https://lkml.org/lkml/2013/9/11/801


