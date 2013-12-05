Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3LETvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:51:55 -0500
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:43025 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751352Ab3LETvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:51:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2903:3138:3139:3140:3141:3142:3622:3653:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:10010:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: cause00_10334e0653b29
X-Filterd-Recvd-Size: 1261
Message-ID: <1386273109.10003.12.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Do not hardcode perl path
From: Joe Perches <joe@perches.com>
To: Jagannadha Sutradharudu Teki 
	<jagannadha.sutradharudu-teki@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
Date: Thu, 05 Dec 2013 11:51:49 -0800
In-Reply-To: <b26e8934-caba-4385-bd32-8f48e2e99826@VA3EHSMHS026.ehs.local>
References: <b26e8934-caba-4385-bd32-8f48e2e99826@VA3EHSMHS026.ehs.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 16:53 +0530, Jagannadha Sutradharudu Teki wrote:
> checkpatch.pl requires perl v5.10.0 to run but it
> doesn't require to place in /usr/bin/perl
> Use env to ensure that the interpreter used is the
> first one on environment's $PATH on system with
> several versions of perl installed.

I don't have an opinion on this patch.

