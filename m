Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaJ1UdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:33:21 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:37661 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027AbaJ1UdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:33:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4321:4423:5007:6120:6261:10004:10400:10848:11658:11914:12517:12519:12555:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blow21_397b8dce6b450
X-Filterd-Recvd-Size: 1138
Message-ID: <1414528393.10912.6.camel@perches.com>
Subject: RFC -next: Converting dev_<level> function to return void
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Oct 2014 13:33:13 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe -next currently has no more uses of the dev_<level>
return value, so it's possible to make these return void.

There are dependencies on changes in drivers/net/wireless/ath
that have just been pulled into next-20141028 but not earlier.

Given the dependencies, when would be a good time to submit
changes to these dev_<level> declarations and uses?

It's not urgent, it could wait until 3.19, but maybe sooner
is better.


