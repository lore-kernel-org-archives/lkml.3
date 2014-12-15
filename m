Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbaLOR1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:27:17 -0500
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:49284 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750774AbaLOR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:27:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3873:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wire62_3f1e53c5c0d31
X-Filterd-Recvd-Size: 1503
Message-ID: <1418664431.2674.19.camel@perches.com>
Subject: Re: [PATCH] Staging: rtl8712: removed an unnecessary else statement
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Karthik Nayak <karthik.188@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Mon, 15 Dec 2014 09:27:11 -0800
In-Reply-To: <548F1686.4080507@lwfinger.net>
References: <1418657154-10481-1-git-send-email-karthik.188@gmail.com>
	 <1418661543.2674.17.camel@perches.com> <548F1686.4080507@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 11:12 -0600, Larry Finger wrote:
> On 12/15/2014 10:39 AM, Joe Perches wrote:
> > On Mon, 2014-12-15 at 20:55 +0530, Karthik Nayak wrote:
> >> As per checkpatch warning, removed an unnecessary else statement
> >> proceeding an if statement with a return.
> >
> > This is not a correct change.
> > The checkpatch message said "generally".
> > You still have to verify the code.
[]
> Perhaps checkpatch should ignore setting this warning when there is an "else if" 
> in the flow.

In a patch, that's not possible as the
context may not show the flow.


