Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3JFWBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 18:01:31 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:45596 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754559Ab3JFWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 18:01:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7903:8957:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12679:12740:13069:13149:13230:13311:13357:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: help09_814c8e922763d
X-Filterd-Recvd-Size: 1581
Message-ID: <1381096886.2081.168.camel@joe-AO722>
Subject: Re: Preferred line-break style around binary operators?
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Sun, 06 Oct 2013 15:01:26 -0700
In-Reply-To: <20131006214829.GA20112@leaf>
References: <20131006214829.GA20112@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-06 at 14:48 -0700, Josh Triplett wrote:
> There are two common approaches to breaking long lines at binary
> operators: breaking the line before the operator (putting the operator
> at the start of the next line), or breaking the line after the operator
> (putting the operator at the end of the previous line).
> 
> CodingStyle doesn't define any requirement here, and the kernel uses
> both approaches; for instance, using && as a sample:
> 
> $ git grep -h '&&$' | wc -l
> 28872
> $ git grep -h '^[[:space:]]*&&' | wc -l
> 4169
> 
> Which style should kernel code use?  I can submit a CodingStyle patch
> documenting that preference for future reference.

That was pretty contentious awhile ago.
An example:
https://lkml.org/lkml/2009/12/5/30

net/ and drivers/net/ use && and || at EOL.

