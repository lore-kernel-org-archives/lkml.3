Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbaGPEuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:50:15 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:40842 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759523AbaGPEuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:50:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:7652:7875:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: foot40_1ec2f6ad1d359
X-Filterd-Recvd-Size: 1600
Message-ID: <1405486209.14773.32.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/get_maintainer: increase threshold for
 --follow to reduce time
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 21:50:09 -0700
In-Reply-To: <CAJhHMCDNj2H7VC+5tMeWqPGbMQpDD-ycZ2HGXoeMPwCn7hTuKg@mail.gmail.com>
References: <1405193128-6848-1-git-send-email-bobby.prani@gmail.com>
	 <CAJhHMCC1bY5ras7-W17Qh7yZq5-_eD0C-CJfa09ZpjWNoTOZ=w@mail.gmail.com>
	 <1405483722.14773.12.camel@joe-AO725>
	 <CAJhHMCDNj2H7VC+5tMeWqPGbMQpDD-ycZ2HGXoeMPwCn7hTuKg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 00:35 -0400, Pranith Kumar wrote:
> The problem is with the default which is at 50% now. That means that a
> commit needs to have changed a file by more than 50% -and- moved it in
> the same commit. This is highly discouraged and unlikely to happen in
> our case.
> 
> Even if we have this a cmd-line configuration, setting the default to
> 90% really makes sense, no?

Dunno.  If it makes sense, maybe it makes global sense
and should be the git default.  If not, maybe other users
have different needs and need some other cmdline option.



