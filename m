Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbaCTUSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:18:44 -0400
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:53167 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759573AbaCTUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:18:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3698:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6117:7652:7901:7903:8957:9010:9012:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,C
X-HE-Tag: word28_68b80f67ff610
X-Filterd-Recvd-Size: 2015
Message-ID: <1395346718.7776.43.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: microblaze: Use LKML as mailing list
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Date: Thu, 20 Mar 2014 13:18:38 -0700
In-Reply-To: <1395346547.29055.2.camel@x220>
References: <4f187754982226c3456c0a9b86050ab4e470aa98.1395328176.git.michal.simek@xilinx.com>
	 <1395346547.29055.2.camel@x220>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 21:15 +0100, Paul Bolle wrote:
> On Thu, 2014-03-20 at 16:09 +0100, Michal Simek wrote:
> > microblaze-uclinux mailing list is almost dead and
> > it is just causing troubles for non subscribers which are
> > getting email about waiting for moderator.
> > Approval never happens. Move it to LKML.
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > @@ -5702,7 +5702,7 @@ F:	fs/imgdafs/
> > 
> >  MICROBLAZE ARCHITECTURE
> >  M:	Michal Simek <monstr@monstr.eu>
> > -L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
> > +L:	linux-kernel@vger.kernel.org
> 
> Isn't lkml already the catch all address that get_maintainer.pl always
> spits out?

'tis.

My preference is not adding L: lkml lines to
individual sections as it is the default and it is
specified as such in the beginning of MAINTAINERS
and SubmittingPatches.

