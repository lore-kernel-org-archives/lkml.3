Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3KEGQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:16:25 -0500
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:57651 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750911Ab3KEGQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:16:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13095:13311:13357:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cats55_1a91b3d8b8944
X-Filterd-Recvd-Size: 1953
Message-ID: <1383632181.4387.18.camel@joe-AO722>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Date: Mon, 04 Nov 2013 22:16:21 -0800
In-Reply-To: <52788A50.6000403@asianux.com>
References: <52738E90.6040104@asianux.com>
	 <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>
	 <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>
	 <527859D9.30109@asianux.com> <1383629008.4387.0.camel@joe-AO722>
	 <5278853E.2000600@asianux.com> <52788606.5070002@asianux.com>
	 <1383630867.4387.11.camel@joe-AO722> <52788A50.6000403@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 14:04 +0800, Chen Gang wrote:
> On 11/05/2013 01:54 PM, Joe Perches wrote:
> > On Tue, 2013-11-05 at 13:45 +0800, Chen Gang wrote:
> >> > If really as what I guess above (some patches no Signed-of-by), is there
> >> > a tool to check and find this issue in time?
> > scripts/checkpatch.pl bleats a message on missing sign-offs.
> 
> Yeah, the author/maintainer can use it for checking.
> 
> But do we have additional tools to let the version tree integrator (e.g.
> sfr) notice about it?

git pre-commit hooks work.

btw: there's some development efforts going on
     that might help here eventually.

Read this thread:
https://lkml.org/lkml/2013/10/26/158


