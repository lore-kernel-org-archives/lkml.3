Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbbAKVOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:14:24 -0500
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:50005 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbbAKVOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:14:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3872:4321:5007:6261:6742:6743:10004:10400:10848:11232:11473:11658:11914:12296:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smile73_7ca1000b2fc08
X-Filterd-Recvd-Size: 1765
Message-ID: <1421010853.9233.7.camel@perches.com>
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
Date: Sun, 11 Jan 2015 13:14:13 -0800
In-Reply-To: <54B2E4DD.90200@nod.at>
References: <1421009571-5279-1-git-send-email-richard@nod.at>
	 <1421009571-5279-4-git-send-email-richard@nod.at>
	 <1421009969.9233.5.camel@perches.com> <54B2E4DD.90200@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 22:02 +0100, Richard Weinberger wrote:
> Am 11.01.2015 um 21:59 schrieb Joe Perches:
> > On Sun, 2015-01-11 at 21:52 +0100, Richard Weinberger wrote:
> >> arp_tables.c has a 16bit aligment ifname_compare(), factor
> >> it out to use it for all tables.
[]
> > Perhaps this would be better as bool ifname_compare
> Let's discuss the whole concept first

The concept seems obvious enough

