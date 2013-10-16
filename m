Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049Ab3JPQzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:55:12 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:39400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760870Ab3JPQzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:55:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime14_49c7823cbc147
X-Filterd-Recvd-Size: 1730
Message-ID: <1381942505.22110.61.camel@joe-AO722>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Wed, 16 Oct 2013 09:55:05 -0700
In-Reply-To: <20131016062541.GA21276@gmail.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381790278.16896.2.camel@joe-AO722>
	 <1381790686.2045.24.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381790982.16896.7.camel@joe-AO722> <20131015074123.GB25493@gmail.com>
	 <1381854064.22110.16.camel@joe-AO722> <20131016062541.GA21276@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 08:25 +0200, Ingo Molnar wrote:
>  Prefetch takes memory from L2->L1 memory 
> just as much as it moves it cachelines from memory to the L2 cache. 

Yup, mea culpa.
I thought the prefetch was still to L1 like the Pentium.


