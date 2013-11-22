Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3KVWpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:45:24 -0500
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:39304 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755338Ab3KVWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:45:22 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3870:3871:3876:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:7652:7875:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vase57_2ea9fe9bef729
X-Filterd-Recvd-Size: 1175
Message-ID: <1385160319.17856.35.camel@joe-AO722>
Subject: Re: [PATCH v2] checkpatch.pl: Check for functions without a real
 prototype
From: Joe Perches <joe@perches.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Fri, 22 Nov 2013 14:45:19 -0800
In-Reply-To: <1385158664-12923-1-git-send-email-ufimtseva@gmail.com>
References: <1385158664-12923-1-git-send-email-ufimtseva@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 17:17 -0500, Elena Ufimtseva wrote:
> Based on Richard Weinberger patch https://lkml.org/lkml/2012/3/16/510
> Functions like this one are evil:
> 
> void foo()
> {
> 	...
> }
[]
> - added white space in regular expression between (), based
> on comments from Joe Perches.

Thanks Elena, but this is already applied in -next.


