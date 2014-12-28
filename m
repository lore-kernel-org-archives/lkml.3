Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaL1Qpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:45:52 -0500
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:38569 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751992AbaL1Qps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:45:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:421:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6261:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tray77_15452be8e7262
X-Filterd-Recvd-Size: 1458
Message-ID: <1419785144.20894.10.camel@perches.com>
Subject: Re: [PATCH 1/1] fs/ufs/super.c: remove unnecessary casting
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 28 Dec 2014 08:45:44 -0800
In-Reply-To: <20141228153311.GI22149@ZenIV.linux.org.uk>
References: <1419780509-4582-1-git-send-email-fabf@skynet.be>
	 <20141228153311.GI22149@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-28 at 15:33 +0000, Al Viro wrote:
> On Sun, Dec 28, 2014 at 04:28:29PM +0100, Fabian Frederick wrote:
> > Fix the following coccinelle warning:
> > fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
> > allocation function to (struct ufs_inode_info *) is useless.
> 
> ... except that it makes allocations harder to grep for.

How does it do that?

> IOW, it's not
> obviously an improvement and should be up to maintainer of the code in
> question.

That's always true in any case.

