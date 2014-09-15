Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaIOPTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:19:38 -0400
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:45903 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752656AbaIOPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:19:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2689:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3866:3868:3870:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:7652:7875:7903:8985:9025:9072:9388:10004:10049:10400:10848:11232:11657:11658:11914:12043:12438:12517:12519:12555:12682:12740:13025:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: table01_3600f9d26022a
X-Filterd-Recvd-Size: 1460
Message-ID: <1410794369.18787.5.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: fix perl v5.20 warning: useless use of
 greediness modifier
From: Joe Perches <joe@perches.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 08:19:29 -0700
In-Reply-To: <1410793970-22778-1-git-send-email-r.peniaev@gmail.com>
References: <1410793970-22778-1-git-send-email-r.peniaev@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 00:12 +0900, Roman Pen wrote:
> on my perl v5.20 I got:
>   Useless use of greediness modifier '+' in regex; marked by
>   <-- HERE in m/(^\+.*) {8,8}+ <-- HERE \t/ at ./scripts/checkpatch.pl line 2427.
> 
> greediness modifier '+' in construction '\s{8,8}+' does not make
> any sense, because we already specify how many chars do we expect.
> 
> Also we can avoid second ',8' and use simple '\s{8}'.

Thanks Roman, it's already fixed in -next.

http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/scripts/checkpatch.pl?id=66cb4ee0e52ca721f609fd5eec16187189ae5fda


