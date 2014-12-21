Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaLURKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:10:04 -0500
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:60770 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751372AbaLURKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:10:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4823:5007:6120:6261:7903:10004:10400:10848:11232:11473:11658:11914:12050:12517:12519:12740:13069:13073:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: list81_739c627da4931
X-Filterd-Recvd-Size: 1760
Message-ID: <1419181792.4200.2.camel@perches.com>
Subject: Re: [RFC PATCH] CodingStyle: remove what nowadays might be
 considered polemic
From: Joe Perches <joe@perches.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2014 09:09:52 -0800
In-Reply-To: <54969F9A.80301@ahsoftware.de>
References: <1418996188-2908-1-git-send-email-holler@ahsoftware.de>
	 <54969F9A.80301@ahsoftware.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-21 at 11:23 +0100, Alexander Holler wrote:
> Am 19.12.2014 um 14:36 schrieb Alexander Holler:
> > In times where things like checkpatch do exist and are mandated to be used,
> > it would be easy to warn if too many levels of indentation are used (e.g.
> > by counting leading tabs).

checkpatch already does that looking for 6+ leading
tabs then any statement that increases indentation.

> I've heared that wrong argument that a maximum line length 
> of 80 chars helps in regard to keep the levels of intendation low once 
> too often.

I believe that argument correct.

helps is not a mandate.

The idea is that code that start far from the left
(for some definition of far) is a signal that code
could be refactored into more discrete chunks.

Without a limit to line length, more code would
likely not have been as disaggregated as today.

