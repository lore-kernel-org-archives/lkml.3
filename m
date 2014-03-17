Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaCQUEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:04:00 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:53290 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750745AbaCQUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:03:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3868:3872:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chess93_5cbcd87a70b28
X-Filterd-Recvd-Size: 1083
Message-ID: <1395086635.2556.28.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Reduce false positives for "Missing blank
 line after declarations" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 17 Mar 2014 13:03:55 -0700
In-Reply-To: <1395081926.2556.27.camel@joe-AO722>
References: <1395081926.2556.27.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 11:45 -0700, Joe Perches wrote:
> Avoid some false positives for this test by adding
> a few common macro types that declare variables.

Self-NAK.  It causes too many other false positives.

I'll play with it awhile and test it better before
posting something else.

