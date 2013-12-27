Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3L0BZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 20:25:43 -0500
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:60242 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753993Ab3L0BZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 20:25:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3870:3874:4321:4362:4605:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: board03_4e985593de837
X-Filterd-Recvd-Size: 1413
Message-ID: <1388107538.30298.0.camel@joe-AO722>
Subject: Re: [PATCH 1/5] checkpatch: Add tests for function pointer style
 misuses
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: akpm@linux-foundation.org, Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Thu, 26 Dec 2013 17:25:38 -0800
In-Reply-To: <20131227005835.GA10986@leaf>
References: <20131227005835.GA10986@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-26 at 16:58 -0800, Josh Triplett wrote:
> On Thu, Dec 26, 2013 at 12:07:23PM -0800, Josh Triplett wrote:
> > On Thu, Dec 26, 2013 at 11:20:28AM -0800, Joe Perches wrote:
> > > Kernel style uses function pointers in this form:
> > >         "type (*funcptr)(args...)"
> > > 
> > > Emit warnings when this function pointer form isn't used.
[]
> Here's a patch that fixes the two messages I commented about, which
> applies on top of the version of the patch that went into -mm.

Acked-by: Joe Perches <joe@perches.com>

thanks Josh, Joe

