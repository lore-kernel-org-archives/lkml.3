Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaJJGU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 02:20:58 -0400
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:32973 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750982AbaJJGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 02:20:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3871:4321:4384:5007:7652:10004:10400:10848:11026:11473:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone00_7de2536b590e
X-Filterd-Recvd-Size: 1351
Message-ID: <1412922052.8770.14.camel@joe-AO725>
Subject: Re: [PATCH 2/2] ALSA: au88x0: pr_* replaced with dev_*
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 23:20:52 -0700
In-Reply-To: <20141010061702.GA4431@sudip-PC>
References: <1412847397-4292-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <1412847397-4292-2-git-send-email-sudipm.mukherjee@gmail.com>
	 <s5hd2a1tlb2.wl-tiwai@suse.de> <1412864283.3438.43.camel@joe-AO725>
	 <20141010061702.GA4431@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 11:47 +0530, Sudip Mukherjee wrote:
> if we remove the prefix then we will not get the exact card name.
> dev_* will print the device name as CARD_NAME_SHORT which will be
> au8810 or au8820 or au8830. 
> so, now waiting for your suggestion ..

I think the au88x0 prefix is sufficient.


