Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3J3N5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:57:05 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:49466 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752640Ab3J3N5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:57:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:10004:10400:10482:10848:11232:11658:11914:12296:12517:12519:12555:12740:13069:13161:13229:13311:13357:19901:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rate96_3d2c4fd6f885d
X-Filterd-Recvd-Size: 1977
Message-ID: <1383141418.12439.76.camel@joe-AO722>
Subject: Re: [PATCH net-next 1/5] lib: crc32: clean up spacing in test cases
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 06:56:58 -0700
In-Reply-To: <1383130252-1515-2-git-send-email-dborkman@redhat.com>
References: <1383130252-1515-1-git-send-email-dborkman@redhat.com>
	 <1383130252-1515-2-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 11:50 +0100, Daniel Borkmann wrote:
> This is nothing more but a whitepace cleanup, as 80 chars is not a
> hard but soft limit, and otherwise makes the test cases arrary really
> look ugly. So fix it up.

That does look nicer.

Another option might be to take the repetitive
6 leading 0's out of column 2 and the repetitive
5 leading 0's out of column 3.

> diff --git a/lib/crc32.c b/lib/crc32.c
[]
> @@ -795,206 +795,106 @@ static struct crc_test {
>  	u32 crc32c_le;	/* expected crc32c_le result */
>  } test[] =
>  {
> -	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1,
> -	 0xf6e93d6c},
> -	{0x35c672c6, 0x0000003a, 0x000001aa, 0xc6d3dfba, 0x28aaf3ad,
> -	 0x0fe92aca},
[etc...]
> +	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
> +	{0x35c672c6, 0x0000003a, 0x000001aa, 0xc6d3dfba, 0x28aaf3ad, 0x0fe92aca},

these could be

+	{0x674bf11d, 0x38, 0x542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
+	{0x35c672c6, 0x3a, 0x1aa, 0xc6d3dfba, 0x28aaf3ad, 0x0fe92aca},

etc...

