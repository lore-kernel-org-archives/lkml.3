Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbaGPEj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:39:58 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:43210 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965047AbaGPEj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:39:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3870:3871:3872:3873:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat66_566cf61dc705c
X-Filterd-Recvd-Size: 1729
Message-ID: <1405485592.14773.29.camel@joe-AO725>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
From: Joe Perches <joe@perches.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 21:39:52 -0700
In-Reply-To: <CAPDOMVi87FAukETbMbjtRqejgFN+mWfqZvP+Uw2eT===Oaz0ww@mail.gmail.com>
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
	 <1405481937.14773.8.camel@joe-AO725>
	 <CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>
	 <1405484621.14773.22.camel@joe-AO725>
	 <CAPDOMVi87FAukETbMbjtRqejgFN+mWfqZvP+Uw2eT===Oaz0ww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 00:28 -0400, Nick Krause wrote:
> I am cleaning up the kernel as it needs a lot of cleanup.

Needs are curious things.

Consistency is a nicety not really a need.

Bugs need fixing.  Defects need eliminating.
Enhancements are appreciated.  Inconsistent
code style is a minor annoyance.

I suggest you focus on the bugs, defects or
enhancements in performance or testing.

Are you really cross-compiling the patches you
submit here or do you have an alpha on your desk?


