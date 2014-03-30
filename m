Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaC3BXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:23:32 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:55563 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752555AbaC3BXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:23:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:3872:4321:5007:6119:6691:7652:7903:10004:10400:10848:11232:11658:11914:12050:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crate96_5882d9aa3ce48
X-Filterd-Recvd-Size: 1575
Message-ID: <1396142606.21529.9.camel@joe-AO722>
Subject: Re: [PATCH 3/3] staging/ozwpan: coding style ether_addr_copy
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: =?ISO-8859-1?Q?J=E9r=F4me?= Pinot <ngc891@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Chris Kelly <ckelly@ozmodevices.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 29 Mar 2014 18:23:26 -0700
In-Reply-To: <20140329232952.GF19296@mwanda>
References: <20140312100132.GA18954@star> <20140312144533.GA3410@kroah.com>
	 <20140313012144.GD30138@star> <20140313022821.GA9084@kroah.com>
	 <20140313153911.GA17881@star> <20140328111801.GD6991@mwanda>
	 <1396012107.31134.21.camel@joe-AO722> <20140329232952.GF19296@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-30 at 02:29 +0300, Dan Carpenter wrote:
> These days in the kernel we treat checkpatch.pl and GCC
> warnings the same so it sucks when they are something conditional.

Treating checkpatch messages like gcc compilation warnings
and failures has got to change.

There is _no way_ checkpatch can have no false positives.


