Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaAGRYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:24:18 -0500
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:56369 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753038AbaAGRYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:24:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2736:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3871:3872:4321:4605:5007:7652:7974:9121:10004:10400:10848:11232:11233:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trade98_40e22f6e8ba06
X-Filterd-Recvd-Size: 1715
Message-ID: <1389115444.32137.9.camel@joe-AO722>
Subject: Re: [PATCH] ipc: whitespace cleanup
From: Joe Perches <joe@perches.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>
Date: Tue, 07 Jan 2014 09:24:04 -0800
In-Reply-To: <1389114734.3095.3.camel@buesod1.americas.hpqcorp.net>
References: <1387897356-6140-1-git-send-email-manfred@colorfullife.com>
	 <1389114734.3095.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 09:12 -0800, Davidlohr Bueso wrote:
> On Tue, 2013-12-24 at 16:02 +0100, Manfred Spraul wrote:
> > The ipc code does not adhere the typical linux coding style.
> > This patch fixes lots of simple whitespace errors.
> 
> While it's no big deal, the title of the patch doesn't really reflect
> the actual changes as it deals with much more than just whitespace
> cleanups. How about something like "ipc: checkpatch fixes"?

Isn't a patch where "git diff -w" is empty
whitespace only cleanups?

$ git diff --help
[]
       -w, --ignore-all-space
           Ignore whitespace when comparing lines. This ignores differences
           even if one line has whitespace where the other line has none.


