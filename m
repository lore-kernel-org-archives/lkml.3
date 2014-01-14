Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaANTM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:12:58 -0500
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:51431 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751894AbaANTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:12:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3872:3873:4321:4362:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: can64_7081ef02e7b09
X-Filterd-Recvd-Size: 1483
Message-ID: <1389726771.24849.49.camel@joe-AO722>
Subject: Re: [PATCH 2/2] audit: Convert int limit uses to u32
From: Joe Perches <joe@perches.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 14 Jan 2014 11:12:51 -0800
In-Reply-To: <1389726456.681.0.camel@flatline.rdu.redhat.com>
References: <f4acac9406b7ec15f859215808e72305e6a3a46a.1389724329.git.joe@perches.com>
	 <7122d36ffb0d82a660bdf16f0c344d7611a5c1e1.1389724329.git.joe@perches.com>
	 <1389726456.681.0.camel@flatline.rdu.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 14:07 -0500, Eric Paris wrote:
> On Tue, 2014-01-14 at 10:33 -0800, Joe Perches wrote:
> > The equivalent uapi struct uses __u32 so make the kernel
> > uses u32 too.
[]
> > diff --git a/kernel/audit.c b/kernel/audit.c
[]
> > @@ -79,16 +79,16 @@ static int	audit_initialized;
[]
> >  /* Default state when kernel boots without any parameters. */
> > -static int	audit_default;
> > +u32	audit_default;
> 
> Can't figure out why you dropped the static...

oops, typo.

> I'm putting it back.

thanks.


