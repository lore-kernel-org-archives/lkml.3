Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbaGAT06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:26:58 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:36259 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754807AbaGAT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:26:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:4321:5007:7576:7652:7903:7974:10004:10400:10848:10967:11026:11232:11658:11914:12438:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hands00_76890bcba1736
X-Filterd-Recvd-Size: 1469
Message-ID: <1404242813.14624.15.camel@joe-AO725>
Subject: Re: [PATCH V2] pcnet32: Neaten and remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: pcnet32@frontier.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org
Date: Tue, 01 Jul 2014 12:26:53 -0700
In-Reply-To: <20140701.121935.729962585105477131.davem@davemloft.net>
References: <1403550950.15811.15.camel@joe-AO725>
	 <1403557507.20657.3.camel@joe-AO725> <1403740525.28663.6.camel@joe-AO725>
	 <20140701.121935.729962585105477131.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 12:19 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com> Date: Wed, 25 Jun 2014 16:55:25 -0700
> > Make the code flow a little better for 80 columns.
[]
> > Still depends on patch 1/22: pci-dma-compat: Add pci_zalloc_consistent helper
> 
> If this has a dependency on a patch I'm not added to my tree, I'm not
> applying this one either.

No worries, Andrew picked them up and they are
queued in -next (with the less good subject prefix)


