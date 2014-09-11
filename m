Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaIKOQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:16:05 -0400
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:49583 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaIKOQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:16:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2376:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:9010:10004:10400:10848:10967:11232:11657:11658:11914:12043:12517:12519:12663:12679:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: force85_8baa1124e6b3f
X-Filterd-Recvd-Size: 2049
Message-ID: <1410444957.9942.3.camel@joe-AO725>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Masanari Iida <standby24x7@gmail.com>,
        linux-doc <linux-doc@vger.kernel.org>
Date: Thu, 11 Sep 2014 07:15:57 -0700
In-Reply-To: <CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
References: <20140908181524.GA11839@www.outflux.net>
	 <20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
	 <CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 09:19 +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 11, 2014 at 12:52 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 8 Sep 2014 11:15:24 -0700 Kees Cook <keescook@chromium.org> wrote:
> >> Check for misspellings, based on Debian's lintian list. Several false
> >> positives were removed, and several additional words added that were
[]
> > I have a feeling this is going to be a rat hole and that
> > scripts/spelling.txt will grow to consume the planet.  Oh well, whatev.
> 
> What about making checkpatch use the codespell dictionay if codespell
> is installed?
> 
> Codespell is in Ubuntu 14.04LTS (but not in 12.04LTS).

I'm a little concerned about false positives if that's
done, but it seems simple enough.

Maybe both of:

codespell:	/usr/share/codespell/dictionary.txt
lintian:	/usr/share/lintian/data/spelling/corrections



