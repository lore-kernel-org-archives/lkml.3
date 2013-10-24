Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JXPJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:09:43 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:44903 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753308Ab3JXPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:09:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:2911:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4425:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: thing66_36c61f15eee23
X-Filterd-Recvd-Size: 1603
Message-ID: <1382627375.22433.58.camel@joe-AO722>
Subject: Re: [PATCH] skd: Replaced custom debug PRINTKs with pr_debug
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Date: Thu, 24 Oct 2013 08:09:35 -0700
In-Reply-To: <20131024115304.GW14598@kernel.dk>
References: <24CA9A5C93173F48A9E3313B866A7C280F344E@MYMBX3.stec-inc.ad>
	 <20131024115304.GW14598@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 12:53 +0100, Jens Axboe wrote:
> On Thu, Oct 24 2013, Ramprasad Chinthekindi wrote:
> > Hi Jens,
> > 
> > I'm resending the patch to replace custom debug macros with
> > pr_debug(). Kindly please review and apply the patch.  Thanking you.
> 
> Thanks, that's a nice improvement. Applied.

Is it really much of an improvement?

It leaves possible different behavior with
skdev->dbg_level/skd_dbg_level set without
linkage to a few printks now.

It also doesn't make use of dynamic debug's
+f/+l capability to and always emits
__func__/__LINE__.


