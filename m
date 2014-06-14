Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaFNIaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 04:30:23 -0400
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:37009 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752178AbaFNIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 04:30:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3874:4321:4552:5007:6120:7652:10004:10400:10848:11232:11658:11914:12295:12296:12517:12519:12740:13069:13071:13161:13229:13255:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coach19_59d3e36c02855
X-Filterd-Recvd-Size: 1775
Message-ID: <1402734615.2756.7.camel@joe-AO725>
Subject: Re: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of
 memory' messages
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        benoit.taine@lip6.fr
Date: Sat, 14 Jun 2014 01:30:15 -0700
In-Reply-To: <alpine.DEB.2.02.1406140937370.2003@localhost6.localdomain6>
References: <1402419340.30479.18.camel@joe-AO725>
	 <20140611074704.GS5015@mwanda> <1402502500.6169.5.camel@joe-AO725>
	 <alpine.DEB.2.02.1406140937370.2003@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-14 at 09:40 +0200, Julia Lawall wrote:
> With a semantic patch that searches for the various calls and then a 
> string containing the letters "emory", I get removals of the messages 
> below.  Do any of these messages look useful?  For example, some are 
> generated with specific functions, such as IRDA_ERROR or BT_ERR.  If none 
> of the messages look useful, should just one big patch go to trivial, or 
> should the patches go to the individual maintainers?
> 
> julia

Hi Julia.

There was no attachment or "below" for your email.

I expect that these should go first to individual
maintainers, then after that and a kernel release
later, then to trivial.


