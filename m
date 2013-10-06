Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3JFV2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:28:11 -0400
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:48480 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380Ab3JFV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:28:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2906:3138:3139:3140:3141:3142:3352:3622:3698:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:6120:7652:7901:10004:10226:10400:10848:11232:11658:11914:12517:12519:12740:13069:13163:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spoon98_7a1efd89bfd0b
X-Filterd-Recvd-Size: 1727
Message-ID: <1381094837.2081.160.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Sun, 06 Oct 2013 14:27:17 -0700
In-Reply-To: <20131006211855.GB19510@leaf>
References: <20131005184307.GA6429@leaf>
	 <1380999108.2081.138.camel@joe-AO722> <20131006062739.GA5218@kroah.com>
	 <20131006211855.GB19510@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-06 at 14:18 -0700, Josh Triplett wrote:
> On Sat, Oct 05, 2013 at 11:27:39PM -0700, Greg Kroah-Hartman wrote:
> > On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> > > On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > > > Kernel maintainers reject new instances of the GPL boilerplate paragraph
> > > > directing people to write to the FSF for a copy of the GPL, since the
> > > > FSF has moved in the past and may do so again.
[]
> any objections to merging the patch in its current form?

Your own suggestion that this be applied only to
patches hasn't been implemented.

This patch emits an ERROR not a WARN or CHK.

It encourages people to modify files that may not
need modification and there hasn't been any agreement
that this is complete.


