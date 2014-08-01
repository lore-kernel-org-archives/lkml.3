Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaHAAkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:40:52 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:40811 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750907AbaHAAkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:40:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3867:3870:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rake99_5e8e918372207
X-Filterd-Recvd-Size: 1421
Message-ID: <1406853648.9953.14.camel@joe-AO725>
Subject: Re: [PATCH v2 1/2] printk: Add function to return log buffer
 address and size
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 31 Jul 2014 17:40:48 -0700
In-Reply-To: <20140731152255.37e675870dfdf77d9dbaff70@linux-foundation.org>
References: <20140731153447.27134.44225.stgit@hegdevasant.in.ibm.com>
	 <20140731152255.37e675870dfdf77d9dbaff70@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 15:22 -0700, Andrew Morton wrote:

> Please include this in whatever tree carries "powerpc/powernv:
> Interface to register/unregister opal dump region".

At some point, I'd like to redo the patch series
that breaks up printk.c into more manageable blocks.

https://lkml.org/lkml/2012/10/17/41

Any suggestion for timing?

