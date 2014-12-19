Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaLSD56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:57:58 -0500
Received: from smtprelay0168.hostedemail.com ([216.40.44.168]:43128 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751567AbaLSD55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:57:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3873:3874:4321:4470:5007:6261:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:14096:14097:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hall13_453006ab3b126
X-Filterd-Recvd-Size: 2185
Message-ID: <1418961473.25129.3.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Fix MAINTAINERS search pattern
From: Joe Perches <joe@perches.com>
To: "Chickles, Derek" <Derek.Chickles@caviumnetworks.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cernekee@gmail.com" <cernekee@gmail.com>
Date: Thu, 18 Dec 2014 19:57:53 -0800
In-Reply-To: <BLUPR07MB4845BEE1160E5945E113E8AFE6B0@BLUPR07MB484.namprd07.prod.outlook.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
	 <1418933533-8364-1-git-send-email-dchickles@caviumnetworks.com>
	 <1418937472.28384.14.camel@perches.com>
	 <BLUPR07MB4845BEE1160E5945E113E8AFE6B0@BLUPR07MB484.namprd07.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 02:34 +0000, Chickles, Derek wrote:
> > On Thu, 2014-12-18 at 12:12 -0800, Derek Chickles wrote:
> > > This fixes the check that was supposed to prevent the MAINTAINERS
> > > warning from appearing when you run checkpatch.pl on a patch that
> > > includes new files/directories and an updated MAINTAINERS file.
> > 
> > This suggested patch doesn't work.
> > 
> > $realfile isn't set until the file shows up
> > in the patch itself.
> > 
> > The current test looks at the changelog
> > before the files are modified and is correct.
> > 
> 
> Thanks, you're right. My mistake was trying to run checkpatch.pl on a diff.
> My patch works on diffs while the original code does not. This is by chance
> really because MAINTAINERS is early in the patch. Using format-patch on
> something that is committed is clearly the correct solution.

Both tests can be used.

Send another patch without deleting the first test
and that'd be good to me.


