Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaF3Xbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:31:36 -0400
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:39346 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752065AbaF3Xbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:31:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3872:3873:3874:4321:5007:7652:10004:10400:10848:10967:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: root71_d824c6710034
X-Filterd-Recvd-Size: 1628
Message-ID: <1404171091.2717.24.camel@joe-AO725>
Subject: Re: [PATCH 1/4] fs.h: Remove unnecessary extern prototypes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 16:31:31 -0700
In-Reply-To: <20140630161944.bd57016cba11f47185dbe6c5@linux-foundation.org>
References: <cover.1403999769.git.joe@perches.com>
	 <c81908e88f71ca2c21a8e3eaf3e5f72bd8d6c322.1403999769.git.joe@perches.com>
	 <20140630161944.bd57016cba11f47185dbe6c5@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 16:19 -0700, Andrew Morton wrote:
> On Sat, 28 Jun 2014 17:20:13 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > This file has a mixture of prototypes with and without extern.
> > Remove the extern uses.
> 
> urgh, it's been two days and this already throws a huge reject.  I fix
> that and the other two patches throw great piles of rejects as well.
> 
> Dunno.  Maybe `diff -u1' will make it feasible.

This was against -next and was done almost completely
by automated tool.

I can fix it and resubmit if you like.


