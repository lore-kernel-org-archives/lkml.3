Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965729AbaLLKQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:16:01 -0500
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:47482 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965640AbaLLKQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:00 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6119:6261:9108:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mint95_3439bb3e53052
X-Filterd-Recvd-Size: 1500
Message-ID: <1418379357.18092.44.camel@perches.com>
Subject: Re: [PATCH v1 0/4] mfd: reorganize Intel drivers
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Fri, 12 Dec 2014 02:15:57 -0800
In-Reply-To: <1418379009.17201.61.camel@linux.intel.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1418314017.18092.35.camel@perches.com>
	 <1418379009.17201.61.camel@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 12:10 +0200, Andy Shevchenko wrote:
> On Thu, 2014-12-11 at 08:06 -0800, Joe Perches wrote:
> > On Thu, 2014-12-11 at 17:53 +0200, Andy Shevchenko wrote:
> > > This patchset creates a new folder under drivers/mfd and moves there Intel
> > > related drivers.
> > 
> > Missing update of MAINTAINERS?
> 
> Oh, right. I could send a follow up patch or update each patch in the
> series. What is the best approach here?

I think it'd be fine to send another patch later on
if/after this is applied.


