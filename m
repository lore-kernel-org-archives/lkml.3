Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKIOWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 09:22:14 -0500
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:37016 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728AbaKIOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 09:22:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3871:3872:3873:3874:4321:5007:6261:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:13848:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blood26_876627e2bb152
X-Filterd-Recvd-Size: 1396
Message-ID: <1415542929.23530.39.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Add --strict preference for #defines using
 BIT(foo)
From: Joe Perches <joe@perches.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 09 Nov 2014 06:22:09 -0800
In-Reply-To: <20141109095025.GA1840@nanopsycho.orion>
References: <1415265610-9338-1-git-send-email-jiri@resnulli.us>
	 <1415265610-9338-10-git-send-email-jiri@resnulli.us>
	 <20141107.151607.480474516800359791.davem@davemloft.net>
	 <1415394939.23530.20.camel@perches.com>
	 <20141109095025.GA1840@nanopsycho.orion>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 10:50 +0100, Jiri Pirko wrote:
> Joe, regarding the other Dave's comment, the multiline one, that is also
> not covered by checkpatch. Would please you take care of that as well?

No, as far as I know, it's not feasible given
insertion/deletion, but you are welcome to try.


