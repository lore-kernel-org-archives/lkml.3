Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3KEFXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:23:33 -0500
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:44955 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704Ab3KEFXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:23:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: board63_17a0f1378a08
X-Filterd-Recvd-Size: 1517
Message-ID: <1383629008.4387.0.camel@joe-AO722>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Nov 2013 21:23:28 -0800
In-Reply-To: <527859D9.30109@asianux.com>
References: <52738E90.6040104@asianux.com>
	 <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>
	 <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>
	 <527859D9.30109@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 10:37 +0800, Chen Gang wrote:
> But after I let it pure next-20131101 ("git reset HEAD^; git stash"), it
> still cause this issue.

It's also because:

> >> Also, there's a defect in function vcs_find_signers.
> >> It should only return the commit count and array references.
> >>
> >> If there are no signers in the commit history interval specified,
> >> then the "authors" array is added to the "signers" array and
> >> returned as a single array.


