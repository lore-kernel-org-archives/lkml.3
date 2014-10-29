Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbaJ2WIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:08:41 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:34206 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757286AbaJ2WIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:08:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3874:4321:4384:5007:6261:10004:10400:10848:11026:11658:11914:12114:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: laugh23_4b517d9c99622
X-Filterd-Recvd-Size: 1301
Message-ID: <1414620516.2542.3.camel@perches.com>
Subject: Re: [RFA][PATCH 1/8] seq_file: Rename seq_overflow() to
 seq_has_overflowed() and make public
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 29 Oct 2014 15:08:36 -0700
In-Reply-To: <20141029220107.333126455@goodmis.org>
References: <20141029215602.535533597@goodmis.org>
	 <20141029220107.333126455@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 17:56 -0400, Steven Rostedt wrote:
> +A true return from seq_has_overflowed means that the seq_file buffer is full
> +and further output will be discarded.

Perhaps the description is a bit unclear here.

Doesn't a return of true to seq_has_overflowed mean that
more characters have already been written than the buffer
can accept?


