Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaGTRgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:36:37 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:34319 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753829AbaGTRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:36:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:7652:7809:7903:9010:10004:10400:10848:11232:11658:11914:12050:12517:12519:12663:12740:13069:13138:13190:13229:13231:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone81_73763d4fe6f4e
X-Filterd-Recvd-Size: 2172
Message-ID: <1405877791.5135.36.camel@joe-AO725>
Subject: Re: Patch priority in subjects ?
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 20 Jul 2014 10:36:31 -0700
In-Reply-To: <1619290298.804838.1405876434000.open-xchange@webmail.nmp.skynet.be>
References: <1619290298.804838.1405876434000.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-20 at 19:13 +0200, Fabian Frederick wrote:
> I was reading all those "friendly" messages around checkpatch -f lately
> and the fact that code clean-up is too noisy (?)
> 
> I guess I'm not the first to think about it but why don't we use something
> like a priority field in patch subject ?
> 
> Of course it would be arbitrary but maybe better than nothing ?
> 
> eg
> 
> [PATCH 1/1 0] Urgent bug fix
> [PATCH 1/1 1] Bug fix
> [PATCH 1/1 2] ...
> [PATCH 1/1 7] kernel-doc fix
> [PATCH 1/1 8] Code clean-up
> [PATCH 1/1 9] Trivial fix
> 
> Maybe this could help some people to sort/filter/delete
> 
> It's just an idea of course...

It's a good idea, but this is more a subject for
discussion on and by the list than off-list so I'm
adding LKML.

As far as I know, the only infrequently used prefixes
today are "RFC" and "trivial".

If you start to use a prefix, please use readable
text and not some numeric table index.

[RFC PATCH]
[URGENT PATCH]
[BUGFIX PATCH]
[TRIVIAL PATCH]
[CODE STYLE PATCH]

etc...

Getting people to use
	git format-patch --subject-prefix="text"
will be the useful part of this challenge.

Maybe you could develop YA little helper script for
that, ideally with versioning support for repeated
patch submissions too.


