Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3IXQ4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:56:01 -0400
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:53711 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754661Ab3IXQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:55:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3690:3865:3867:3870:3871:5007:7652:10004:10400:10848:11658:11914:12043:12438:12517:12519:12555:13069:13163:13229:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meat13_6e1caab6a8032
X-Filterd-Recvd-Size: 1216
Message-ID: <1380041755.3575.93.camel@joe-AO722>
Subject: Re: [PATCH 04/10] amd/7990: Remove extern from function prototypes
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Sep 2013 09:55:55 -0700
In-Reply-To: <65ef2eba58fddc268ba0afb4de7757f073d3bb49.1379974101.git.joe@perches.com>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
	 <65ef2eba58fddc268ba0afb4de7757f073d3bb49.1379974101.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey David.

This ended up in your tree as
commit 44da5c2f523876a02336c18dbcce93449fdbf0ca
without your signoff.

Is there something I need to do differently so
your scripts add your sign-off properly or did
this manage to just slip through via some manual
git am without the -s?


