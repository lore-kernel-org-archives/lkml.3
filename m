Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaJPIus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:50:48 -0400
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:37877 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750765AbaJPIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:50:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3866:3874:4321:5007:6261:7901:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: earth94_40760e78c262a
X-Filterd-Recvd-Size: 1299
Message-ID: <1413449441.7484.22.camel@perches.com>
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by kzalloc
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 16 Oct 2014 01:50:41 -0700
In-Reply-To: <346236957.6316.1413446930736.open-xchange@webmail.nmp.skynet.be>
References: <1413304831-7203-1-git-send-email-fabf@skynet.be>
	 <1413306955.3269.30.camel@joe-AO725> <87iojm8qxp.fsf@nemi.mork.no>
	 <346236957.6316.1413446930736.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 10:08 +0200, Fabian Frederick wrote:
> Adding a structure would be a nice design update indeed but this would require
> some testing...Separate patch maybe ?

Of course that'd be fine.


