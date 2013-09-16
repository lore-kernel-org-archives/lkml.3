Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab3IPTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 15:25:56 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:56951 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751040Ab3IPTZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 15:25:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: event92_50620d4567f0c
X-Filterd-Recvd-Size: 1639
Message-ID: <1379359550.1963.2.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: George Spelvin <linux@horizon.com>
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        keescook@chromium.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
Date: Mon, 16 Sep 2013 12:25:50 -0700
In-Reply-To: <20130916191520.8844.qmail@science.horizon.com>
References: <20130916191520.8844.qmail@science.horizon.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 15:15 -0400, George Spelvin wrote:
> > It'd be consistent with all the other %p<foo> types.
> >
> > vsnprintf is already weird enough with %p uses,
> > there's absolutely no reason to stretch it further
> > with yet another odd access/format style.
> 
> Well, all the other %p<foo> types actually *use* the void * argument.
> They print the thing pointed to, just in different ways.
> 
> What I'm proposing is fundamentally different, and much more
> "printf internals" specific.
> 
> I hate creating an interface that requires a dummy pointer argument.
[]
> Is "%0-127c" too ugly to live?

Yes.

I suppose you use "%[-]*pV" if you really want funky/fugly.


