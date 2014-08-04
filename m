Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaHDQCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:02:36 -0400
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:32941 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751033AbaHDQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:02:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3653:3866:3867:3872:3873:3874:4321:5007:7652:9012:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: light96_162b366c82142
X-Filterd-Recvd-Size: 1428
Message-ID: <1407168151.16152.77.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Add uninitialized_var to the
 declaration_macro list
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dotan Barak <dotanb@mellanox.com>, Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Aug 2014 09:02:31 -0700
In-Reply-To: <1407138992.16152.53.camel@joe-AO725>
References: <9084ad9a17844ed898132853d161b495@DB3PR05MB380.eurprd05.prod.outlook.com>
	 <1407138992.16152.53.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 00:56 -0700, Joe Perches wrote:
> Using uninitialized_var reports a false positive for
> "Missing blank line after declarations".
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +our $declaration_macros = qr{(?x:
> +	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|

Hey Andrew.

Dotan showed some variants that could be added to this
line.  Do you want it rolled into a V2 of this patch
or as a separate patch?


