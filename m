Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbaGPEXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:23:46 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:46921 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756715AbaGPEXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:23:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3872:3873:3874:4321:5007:6691:7652:8531:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:13618:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: balls50_5a92a020bdf2e
X-Filterd-Recvd-Size: 2203
Message-ID: <1405484621.14773.22.camel@joe-AO725>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
From: Joe Perches <joe@perches.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 21:23:41 -0700
In-Reply-To: <CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
	 <1405481937.14773.8.camel@joe-AO725>
	 <CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 00:16 -0400, Nick Krause wrote:
> On Tue, Jul 15, 2014 at 11:38 PM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2014-07-15 at 22:50 -0400, Nick Krause wrote:
> >> I may have not found it myself but if it doesn't exist can we write a
> >> feature for checkpatch to be able to recursively
> >> search a directory structure with a -d aRrgument in order to make it
> >> easier to search larger directories for files that still
> >> need cleanup for files having kernel coding style issues.
> >linux-kernel@vger.kernel.org
> > xargs already works fine.
> >
> > git ls-files <dir>/*.[ch] | xargs ./scripts/checkpatch.pl -f
> >
> > I suggest you only use anything like this
> > on staging directories.
> >
> >
> 
> Thanks Joe,
> That was what I needed to known :). I was hitting some errors in arch,
> so I will run that to see if there are any others.
> Cheers Nick

I again suggest you _ONLY_ use checkpatch on staging.

Doing checkpatch only cleanups will not make you a
better developer nor give you a good understanding
of the code operation.

