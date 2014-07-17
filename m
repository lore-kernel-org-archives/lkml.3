Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222AbaGQQZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:25:07 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:45062 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964819AbaGQQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:25:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3622:3865:3868:3871:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12294:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain49_2b896fadc114c
X-Filterd-Recvd-Size: 1317
Message-ID: <1405614291.12363.25.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, tytso@mit.edu, dwalter@google.com, bp@suse.de,
        neilb@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 09:24:51 -0700
In-Reply-To: <20140717160236.GD22791@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
	 <1405612283.12363.10.camel@joe-AO725> <20140717160236.GD22791@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 18:02 +0200, Borislav Petkov wrote:
> On Thu, Jul 17, 2014 at 08:51:23AM -0700, Joe Perches wrote:
> > grep is a similar tool, just less automated.
[]
> checkpatch should only check patches and not whole file.
> It is wrong. Fullstop.

<eh>  No worries, we just disagree about the fullstop.

cheers, Joe


