Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaFZAFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:05:13 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:41214 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752688AbaFZAFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:05:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3872:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mark98_fe583d395335
X-Filterd-Recvd-Size: 1185
Message-ID: <1403741107.28663.9.camel@joe-AO725>
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 17:05:07 -0700
In-Reply-To: <20140625154629.GA21519@thin>
References: <20140625154629.GA21519@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> Regardless of the long-standing debate over line width, checkpatch
> should not warn about it by default.

I'm not getting involved here.

I don't care much one way or another.

I did submit a patch where I ignored 80
columns recently and I was told to try
again by the maintainer.


