Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaFZCdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:33:09 -0400
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:45776 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755438AbaFZCdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:33:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4321:5007:6119:7652:7903:8957:10004:10226:10400:10848:11232:11658:11914:12294:12517:12519:12663:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: side92_8f5ef2aaa7559
X-Filterd-Recvd-Size: 1818
Message-ID: <1403749983.7977.6.camel@joe-AO725>
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 19:33:03 -0700
In-Reply-To: <20140626022448.GA22091@thin>
References: <20140625154629.GA21519@thin>
	 <1403741107.28663.9.camel@joe-AO725> <20140626022448.GA22091@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 19:24 -0700, Josh Triplett wrote:
> On Wed, Jun 25, 2014 at 05:05:07PM -0700, Joe Perches wrote:
> > On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> > > Regardless of the long-standing debate over line width, checkpatch
> > > should not warn about it by default.
> > 
> > I'm not getting involved here.
> > I don't care much one way or another.
[]
> I'm not asking you to get involved in the Great Line Length Debate;
> that's why I didn't attempt to patch CodingStyle or similar.  However, I
> think it makes sense for *checkpatch* to stop emitting this warning.

I think checkpatch should encourage people to write code in
a style that matches CodingStyle as well as the predominant
styles used in the rest of the kernel.

> I'm hoping that Greg will chime in, as the maintainer of staging and the
> recipient of a huge number of checkpatch-motivated patches.



