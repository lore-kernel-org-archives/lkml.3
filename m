Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaLDBoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:44:04 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:52397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751877AbaLDBoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:44:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4250:4321:5007:6117:6119:6261:7901:7903:8531:9040:10004:10400:10471:10848:11232:11658:11914:12517:12519:12740:13069:13095:13255:13311:13357:21060:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: head62_3fe98f01f3260
X-Filterd-Recvd-Size: 1820
Message-ID: <1417657437.2902.27.camel@perches.com>
Subject: Re: [PATCH] Staging: bcm: Fix lines exceeding 80 character limit in
 CmHost.h This is a patch to CmHost.h that fixes Exceeds 80 Character limits
 warning found by checkpatch.pl Signed-off-by: Arun Ayyer <arun267@gmail.com>
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: arun vijayshankar <arun267@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Wed, 03 Dec 2014 17:43:57 -0800
In-Reply-To: <20141204013925.GA32401@kroah.com>
References: <1417655529-8640-1-git-send-email-arun267@gmail.com>
	 <20141204012517.GA31563@kroah.com>
	 <CAJ8d=beEFz-wKaN4bodZFN9BCrUsZKy=F0e-R7fUVXsf+04g4A@mail.gmail.com>
	 <20141204013925.GA32401@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 17:39 -0800, Greg KH wrote:
> On Wed, Dec 03, 2014 at 05:31:59PM -0800, arun vijayshankar wrote:
> > Hi Greg,
> 
> If you turn off HTML email, your message will not get rejected by the
> mailing lists :)
> 
> > I completely agree! I thought of keeping the patch summary as the subject, but
> > I wasn't sure and ending up entering nothing. Git then used this by default.
> 
> You forgot a blank line after your first line in the git commit message,
> which caused it to get all merged together.
> 
> Try fixing that up and resending please.

No need.  This directory has been deleted.

Please work against -next (or Greg's staging tree)


