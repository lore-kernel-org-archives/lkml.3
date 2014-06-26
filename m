Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaFZF3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:29:34 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:53395 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050AbaFZF3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:29:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4823:5007:6691:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13019:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beam96_5333f85452241
X-Filterd-Recvd-Size: 1633
Message-ID: <1403760570.7977.28.camel@joe-AO725>
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 22:29:30 -0700
In-Reply-To: <20140626050824.GB1645@thin>
References: <20140625154629.GA21519@thin>
	 <1403741107.28663.9.camel@joe-AO725> <20140626022448.GA22091@thin>
	 <1403749983.7977.6.camel@joe-AO725> <20140626034430.GA22836@thin>
	 <1403756211.7977.22.camel@joe-AO725> <20140626050824.GB1645@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 22:08 -0700, Josh Triplett wrote:

> Now, arguably the four leading tabs on those lines suggest the need for
> some code refactoring; personally, I'd suggest changing DEEP_INDENTATION
> to flag 4+ tabs rather than 6+ tabs as it currently does.

There are _way too many_ 4+ tab indents for that to
be sensible.

> "trigraphs"?  Do you mean ternaries?  Yeah,

Yup, those.

> Yeah, that one makes sense: if you have a comment to the right of a long
> line, and the comment is what's making it long, it's easy enough to move
> the comment before the line.



