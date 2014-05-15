Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaEOSxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:53:06 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:56968 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681AbaEOSxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:53:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3872:3876:4321:5007:6119:7652:7901:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: group76_8eedf06c1d048
X-Filterd-Recvd-Size: 1275
Message-ID: <1400179978.5058.17.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/hfsplus/wrapper.c: replace min/casting by min_t
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        akpm <akpm@linux-foundation.org>
Date: Thu, 15 May 2014 11:52:58 -0700
In-Reply-To: <20140515190526.5aa91e3af48a2a558603841c@skynet.be>
References: <20140515190526.5aa91e3af48a2a558603841c@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 19:05 +0200, Fabian Frederick wrote:
> Also add * before function comments (it was not detected by
> kernel-doc)
[]
> diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
[]
> @@ -234,7 +234,7 @@ reread:
>  	sbi->alloc_blksz_shift = 0;
>  	while ((blocksize >>= 1) != 0)
>  		sbi->alloc_blksz_shift++;

Unrelated, but perhaps this while loop
should use fls instead.


