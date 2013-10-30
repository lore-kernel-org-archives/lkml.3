Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3J3PPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:15:00 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:52183 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753112Ab3J3PO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:14:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3873:3874:4321:5007:7652:9036:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cream24_de0d449a2748
X-Filterd-Recvd-Size: 1710
Message-ID: <1383146094.9435.3.camel@joe-AO722>
Subject: Re: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 08:14:54 -0700
In-Reply-To: <52711481.8030003@redhat.com>
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
	 <1383130252-1515-2-git-send-email-dborkman@redhat.com>
	 <1383141418.12439.76.camel@joe-AO722>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73C8@saturn3.aculab.com>
	 <52711481.8030003@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 15:15 +0100, Daniel Borkmann wrote:
> On 10/30/2013 03:10 PM, David Laight wrote:
> >>> +	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
> >> these could be
> >> +	{0x674bf11d, 0x38, 0x542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
> > Or even:
> > #define X(a, b, c, d, e, f) {0x##a, 0x##b, 0x##c, 0x##d, 0x##e. 0x##f}
> > 	X(674bf11d, 38, 542, 0af6d466, d8b6e4c1, f6e93d6c),
> > ...
> > #undef X
> 
> Sure, sounds good to me. We could do that as a follow-up.

I personally don't care for that sort of token-pasting macro
but, <shrug> if you want, I've no real objection either.

