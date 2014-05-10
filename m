Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaEJErW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 00:47:22 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:46272 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750739AbaEJErU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 00:47:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3870:3871:3872:3874:4321:4605:5007:7576:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: size33_22b9e1a8a9c07
X-Filterd-Recvd-Size: 1517
Message-ID: <1399697236.2912.43.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: Fix checkpatch false positive due to
 ternary operator break
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: akpm@linux-foundation.org, David Ertman <davidx.m.ertman@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 09 May 2014 21:47:16 -0700
In-Reply-To: <1399696911-6550-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1399696911-6550-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 21:41 -0700, Jeff Kirsher wrote:
> From: David Ertman <davidx.m.ertman@intel.com>

Hey David.

> Using the intuitive breaking of a ternary operator used in the
> initialization of a variable in its declaration:
> 
> type var = FOO ?
>            BAR :
>            FEE;
[]
> type var = FOO
>            ? BAR
>            : FEE;
> 
> Change checkpatch so that it is checking fot the correct breaking of ternary
> operators used in networking variable declaration/initialization.

There is no "correct" breaking for ternary operators.
Both should be acceptable.


