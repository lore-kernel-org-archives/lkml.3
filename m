Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaBZWEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:04:23 -0500
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:58831 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753647AbaBZWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:04:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2687:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:5007:6117:6119:7652:9010:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13095:13161:13229:13311:13357:14096:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: women30_2584a64375e1c
X-Filterd-Recvd-Size: 2060
Message-ID: <1393452256.24588.5.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
From: Joe Perches <joe@perches.com>
To: Tom Rini <trini@ti.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Feb 2014 14:04:16 -0800
In-Reply-To: <530C8D00.8070606@ti.com>
References: <1393274296-26179-1-git-send-email-trini@ti.com>
	 <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>
	 <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com>
	 <1393279377.11020.66.camel@joe-AO722> <530BC209.2000708@ti.com>
	 <1393279691.11020.69.camel@joe-AO722> <530BC5A4.4060803@ti.com>
	 <1393281098.11020.82.camel@joe-AO722> <530BCB27.5040808@ti.com>
	 <1393305803.11020.119.camel@joe-AO722> <530C8D00.8070606@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 07:30 -0500, Tom Rini wrote:
> The only intentional differences we have today are adding debug/printf
> to the list of log functions

That seems fine and trivial to keep current.

> and pointing people at boards.cfg not
> CHECKPATCH in MAINTAINERS,

That seems wrong.

The idea of that message is to fix defects in checkpatch,
not any other code.

Maybe that could be reworded to
"See the CHECKPATCH entry in the MAINTAINERS file of linux git"
or some such.

>  so I can re-sync us no problem as, yup, we're
> about a year out of date there.  Oh and I see now someone snuck in a
> check for whitespace before semi-colon to catch 'return 0 ;' which I'll
> check real quick isn't something already caught and if not post that as
> well.

Does anyone know of other projects that use checkpatch?


