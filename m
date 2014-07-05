Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaGEVXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 17:23:01 -0400
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:40670 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751802AbaGEVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 17:23:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3874:4321:5007:6117:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: veil46_371b3630dfe42
X-Filterd-Recvd-Size: 1490
Message-ID: <1404595377.6384.77.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Emit a warning on file add/move/delete
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jul 2014 14:22:57 -0700
In-Reply-To: <20140704151128.GC20758@bark>
References: <1404434816.6384.5.camel@joe-AO725>
	 <20140704151128.GC20758@bark>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 16:11 +0100, Andy Whitcroft wrote:
> On Thu, Jul 03, 2014 at 05:46:56PM -0700, Joe Perches wrote:
> > Whenever files are added, moved, or deleted, the
> > MAINTAINERS file patterns can be out of sync or
> > outdated.
> > 
> > To try to keep MAINTAINERS more up-to-date, add a
> > one-time warning whenever a patch does any of those.
[]
> That seems like a sensible plan.  Sometime we might try and work out if
> any entries are affected or needed.

Hey again Andy.

Just fyi: I think this is not possible.

A patch series will often add or delete a file
independently from an earlier or later patch that
modifies MAINTAINERS.


