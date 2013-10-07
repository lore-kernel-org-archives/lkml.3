Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3JGT2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:28:31 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:37850 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755538Ab3JGT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:28:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:6119:6120:7264:7652:7903:8957:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rod14_fb72a889a55d
X-Filterd-Recvd-Size: 2016
Message-ID: <1381174106.2081.207.camel@joe-AO722>
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: torvalds@linux-foundation.org, gregkh@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 07 Oct 2013 12:28:26 -0700
In-Reply-To: <20131007191835.GA28737@jtriplet-mobl1>
References: <20131007191835.GA28737@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 12:18 -0700, Josh Triplett wrote:
> The 80-character limit is not a hard-and-fast rule, nor should it be
> applied blindly by people running checkpatch and fixing its warnings.
> Sometimes it's better to violate the 80-character "limit" in the name of
> readability, and when it isn't, it's often better to refactor into a
> function or otherwise restructure the code rather than just finding
> increasingly awkward places to break lines.
> 
> Thus, change checkpatch's LONG_LINE warning to a --strict CHK instead.
> Anyone wanting to use checkpatch to check for this can easily enough
> enable --strict or turn on LONG_LINE explicitly, but it shouldn't be
> part of the default warnings.

I don't agree with this.

CodingStyle says:
----------------------
The limit on the length of lines is 80 columns and this is a strongly
preferred limit.
----------------------

People should be encouraged to use 80 column lines and as well
should learn to ignore messages they don't agree with.

If people are using checkpatch prior to any scripted git am,
then just as easily they could add --ignore=LONG_LINE.


