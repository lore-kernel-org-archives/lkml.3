Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaILJnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:43:19 -0400
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:50275 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753233AbaILJnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:43:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2903:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:4321:5007:6120:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grape22_90cfa8923214c
X-Filterd-Recvd-Size: 1504
Message-ID: <1410514993.9942.28.camel@joe-AO725>
Subject: Re: [PATCH/RFC 1/2] lib: string: Remove duplicated function
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Date: Fri, 12 Sep 2014 02:43:13 -0700
In-Reply-To: <87d2b1jjqa.fsf@rasmusvillemoes.dk>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1409124962-11527-2-git-send-email-linux@rasmusvillemoes.dk>
	 <20140911152241.22ce7f1ebecef7ce7e01b112@linux-foundation.org>
	 <87d2b1jjqa.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 11:01 +0200, Rasmus Villemoes wrote:
> Would it make sense to add a checkpatch warning to ensure new users
> are not introduced, and then remove it when the wrapper is also removed?

<shrug> Generally the rate of introduction is pretty low.

Generally, just making sure it's not used is good enough.

