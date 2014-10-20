Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaJTXLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:11:25 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:43862 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753430AbaJTXLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:11:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13095:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pull22_6341d9b927b44
X-Filterd-Recvd-Size: 1435
Message-ID: <1413846680.5407.4.camel@perches.com>
Subject: Re: [PATCH] scripts, checkpatch.pl, provide a better output message
 for commit id format [v2]
From: Joe Perches <joe@perches.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Mon, 20 Oct 2014 16:11:20 -0700
In-Reply-To: <1413845376-2128-1-git-send-email-prarit@redhat.com>
References: <1413845376-2128-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 18:49 -0400, Prarit Bhargava wrote:
> I tested this using both lower and upper case 'c' with the following commit
> text:
[]

I think the patch subject be something like:

"[PATCH] checkpatch: improve commit id/desc style checking in commit message"

The [v2] goes in the subject like this:

"[PATCH V2] checkpatch: ..."

> 11 chars, SHOULD FAIL
> commit 1234567890a

[]

> ERROR: Please use 12 or more chars for the git commit ID
> commit 1234567890a

I'd expect these messages to mention something about the
missing commit description too.


