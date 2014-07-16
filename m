Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbaGPDjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:39:06 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:36552 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932943AbaGPDjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:39:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3351:3622:3867:3870:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spot81_88ad4fc620b62
X-Filterd-Recvd-Size: 1531
Message-ID: <1405481937.14773.8.camel@joe-AO725>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
From: Joe Perches <joe@perches.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Jul 2014 20:38:57 -0700
In-Reply-To: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 22:50 -0400, Nick Krause wrote:
> I may have not found it myself but if it doesn't exist can we write a
> feature for checkpatch to be able to recursively
> search a directory structure with a -d argument in order to make it
> easier to search larger directories for files that still
> need cleanup for files having kernel coding style issues.

xargs already works fine.

git ls-files <dir>/*.[ch] | xargs ./scripts/checkpatch.pl -f

I suggest you only use anything like this
on staging directories.


