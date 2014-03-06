Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaCFScd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:32:33 -0500
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:55824 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751817AbaCFScc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:32:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3873:3874:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boats34_6d07f7c57a149
X-Filterd-Recvd-Size: 1335
Message-ID: <1394130747.12070.75.camel@joe-AO722>
Subject: Re: [PATCH 1/1] fs: gfs2: global conversion to pr_foo()
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Thu, 06 Mar 2014 10:32:27 -0800
In-Reply-To: <1394128779.2729.25.camel@menhir>
References: <20140305220642.9405a88f040c5d5f183e1119@skynet.be>
	 <1394120644.2729.21.camel@menhir>  <1394128025.12070.73.camel@joe-AO722>
	 <1394128779.2729.25.camel@menhir>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 17:59 +0000, Steven Whitehouse wrote:
> Ok, I think I've got all of Fabian's patch now. Can you send me an
> updated patch that I can put into my tree based on top of whats in the
> -nmw tree now? Otherwise I think things will be a bit too confusing,

No worries, but maybe you need to push the change?
As far as I can tell, what's there now is the same.


