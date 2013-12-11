Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3LKBfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:35:16 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:46922 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751139Ab3LKBfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:35:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3871:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: food52_6741d1fdd3923
X-Filterd-Recvd-Size: 1463
Message-ID: <1386725708.8168.25.camel@joe-AO722>
Subject: Re: [patch] checkpatch: add warning of future __GFP_NOFAIL use
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Tue, 10 Dec 2013 17:35:08 -0800
In-Reply-To: <alpine.DEB.2.02.1312101624330.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com>
	 <20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org>
	 <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1312101618530.22701@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1312101624330.22701@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 16:26 -0800, David Rientjes wrote:
> gfp.h and page_alloc.c already specify that __GFP_NOFAIL is deprecated and 
> no new users should be added.
> 
> Add a warning to checkpatch to catch this.

Fine by me.


