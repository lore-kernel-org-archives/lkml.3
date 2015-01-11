Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbbAKVjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:39:45 -0500
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:34994 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750876AbbAKVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:39:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:6742:6743:7903:9025:9036:10004:10400:10848:11232:11473:11658:11914:12043:12050:12296:12517:12519:12740:13019:13069:13161:13229:13311:13357:13845:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes90_372355b22be00
X-Filterd-Recvd-Size: 2336
Message-ID: <1421012376.9233.9.camel@perches.com>
Subject: Re: [PATCH 3/3] x_tables: Factor out 16bit aligment ifname_compare()
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: davem@davemloft.net, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bhutchings@solarflare.com,
        john.fastabend@gmail.com, herbert@gondor.apana.org.au,
        vyasevic@redhat.com, jiri@resnulli.us, vfalico@gmail.com,
        therbert@google.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru, kadlec@blackhole.kfki.hu,
        kaber@trash.net, pablo@netfilter.org, kay@vrfy.org,
        stephen@networkplumber.org
Date: Sun, 11 Jan 2015 13:39:36 -0800
In-Reply-To: <54B2EB81.5050604@nod.at>
References: <1421009571-5279-1-git-send-email-richard@nod.at>
	 <1421009571-5279-4-git-send-email-richard@nod.at>
	 <1421009969.9233.5.camel@perches.com> <54B2E4DD.90200@nod.at>
	 <1421010853.9233.7.camel@perches.com> <54B2EB81.5050604@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 22:30 +0100, Richard Weinberger wrote:
> Am 11.01.2015 um 22:14 schrieb Joe Perches:
> > On Sun, 2015-01-11 at 22:02 +0100, Richard Weinberger wrote:
> >> Am 11.01.2015 um 21:59 schrieb Joe Perches:
> >>> On Sun, 2015-01-11 at 21:52 +0100, Richard Weinberger wrote:
> >>>> arp_tables.c has a 16bit aligment ifname_compare(), factor
> >>>> it out to use it for all tables.
> > []
> >>> Perhaps this would be better as bool ifname_compare
> >> Let's discuss the whole concept first
> > 
> > The concept seems obvious enough
> 
> Anyway, I agree with Linus wrt. bool.
> https://lkml.org/lkml/2013/8/31/138

I don't.  He was right when he wrote:

https://lkml.org/lkml/2014/3/10/760

Linus Torvalds <>
I guess I haven't gotten over my hatred of people playing games with
them because support wasn't universal enough. But maybe it's
approaching being irrational these days.



