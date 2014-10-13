Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaJMUZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:25:47 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:49099 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342AbaJMUZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:25:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3872:3874:4321:4362:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cent43_894c47ce3ab59
X-Filterd-Recvd-Size: 1109
Message-ID: <1413231942.1287.20.camel@joe-AO725>
Subject: Re: [PATCH 1/1 linux-next] scripts/checkpatch.pl: fix k[mz]alloc
 with multiplies check
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 13 Oct 2014 13:25:42 -0700
In-Reply-To: <1413230802-5507-1-git-send-email-fabf@skynet.be>
References: <1413230802-5507-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 22:06 +0200, Fabian Frederick wrote:
> checkpatch doesn't seem to detect any case since 
> Commit e367455a9f25
> ("checkpatch: emit fewer kmalloc_array/kcalloc conversion warnings")

It seems that worked too well.

Thanks, I'll look at it.


