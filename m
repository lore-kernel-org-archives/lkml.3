Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3JZTvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 15:51:25 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:49389 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753120Ab3JZTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 15:51:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:4321:5007:7652:10004:10400:10471:10848:11026:11232:11658:11914:12114:12438:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone33_bf32e633be03
X-Filterd-Recvd-Size: 1554
Message-ID: <1382817080.3238.12.camel@joe-AO722>
Subject: Re: [PATCH] printk: pr_debug_ratelimited: check state first to
 reduce "callbacks suppressed" messages
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Sat, 26 Oct 2013 12:51:20 -0700
In-Reply-To: <20131026190151.GA26389@kroah.com>
References: <20131026132955.GA9251@shrek.podlesie.net>
	 <20131026173730.GA18320@kroah.com> <1382813522.3238.4.camel@joe-AO722>
	 <20131026190151.GA26389@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 20:01 +0100, Greg Kroah-Hartman wrote:
> On Sat, Oct 26, 2013 at 11:52:02AM -0700, Joe Perches wrote:
> > pr_debug_ratelimited should be coded similar to dev_dbg_ratelimited
> > to reduce the "callbacks suppressed" messages.
> > Signed-off-by: Joe Perches <joe@perches.com>
> Looks good, I'll queue both of these up soon.

Sorry Greg, hand out the brown paper bag please.

Just ignore these both, I'll resubmit properly tested ones.

