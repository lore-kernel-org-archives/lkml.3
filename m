Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaLJOvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:51:52 -0500
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:56349 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753905AbaLJOvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:51:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3871:4321:5007:6261:10011:10400:10481:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:19900:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: wren22_fd37213cb861
X-Filterd-Recvd-Size: 1448
Message-ID: <1418223106.18092.1.camel@perches.com>
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
From: Joe Perches <joe@perches.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 10 Dec 2014 06:51:46 -0800
In-Reply-To: <54880124.8040509@cn.fujitsu.com>
References: <5487DBD9.1010908@cn.fujitsu.com>
	 <1418194583.1047.8.camel@perches.com> <54880124.8040509@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 16:15 +0800, Gu Zheng wrote:
> On 12/10/2014 02:56 PM, Joe Perches wrote:
> > On Wed, 2014-12-10 at 13:36 +0800, Gu Zheng wrote:
> >> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
> >> cmsghdr from msghdr, just cleanup. 
> > 
> > This looks nicer.
> > Ideally this would have used: [PATCH V3] as the subject
> 
> The previous v2 thread was marked as mistake, so this is the really active
> v2 version.

A buggy submitted version is still a version.
Using an incremented version number helps.

