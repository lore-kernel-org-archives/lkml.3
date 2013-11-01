Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3KATpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:45:35 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:60449 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753279Ab3KATpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:45:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: story21_1319219a3ec48
X-Filterd-Recvd-Size: 1775
Message-ID: <1383335129.3042.10.camel@joe-AO722>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Doug Ledford <dledford@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 01 Nov 2013 12:45:29 -0700
In-Reply-To: <20131101173701.GC8467@hmsreliant.think-freely.org>
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com>
	 <20131030110214.GA10220@localhost.localdomain>
	 <52710B09.6090302@redhat.com>
	 <20131031183003.GC25894@hmsreliant.think-freely.org>
	 <1383320566.1737.0.camel@bwh-desktop.uk.level5networks.com>
	 <20131101160802.GB8467@hmsreliant.think-freely.org>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73D3@saturn3.aculab.com>
	 <20131101173701.GC8467@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 13:37 -0400, Neil Horman wrote:

> I think it would be better if we just did the prefetch here
> and re-addressed this area when AVX (or addcx/addox) instructions were available
> for testing on hardware.

Could there be a difference if only a single software
prefetch was done at the beginning of transfer before
the while loop and hardware prefetches did the rest?



