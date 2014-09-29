Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaI2QzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:55:18 -0400
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:56824 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753507AbaI2QzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:55:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3870:3871:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: low11_67a3544ad5b60
X-Filterd-Recvd-Size: 1439
Message-ID: <1412009710.4302.32.camel@joe-AO725>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with
 seq_puts()
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Sep 2014 09:55:10 -0700
In-Reply-To: <20140929124246.3e39dac8@gandalf.local.home>
References: <20140926143721.52206f95@gandalf.local.home>
	 <20140929144121.GA30562@pathway.suse.cz>
	 <20140929154711.GF7996@ZenIV.linux.org.uk>
	 <1412006881.4302.29.camel@joe-AO725>
	 <20140929121534.34c3ebd9@gandalf.local.home>
	 <1412008235.4302.31.camel@joe-AO725>
	 <20140929124246.3e39dac8@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 12:42 -0400, Steven Rostedt wrote:
> Although I like seq_is_full() over seq_is_buf_full(), I'll take either.
> If Al would ack those patches I'd be happy to take them in.

seq_is_full is fine with me too.


