Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168Ab3JPRR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:17:56 -0400
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:38799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760856Ab3JPRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:17:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2840:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3868:3872:3873:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13071:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drug88_7e45a5886ae46
X-Filterd-Recvd-Size: 1882
Message-ID: <1381943866.22110.71.camel@joe-AO722>
Subject: Re: [PATCH] ipc/sem.c: fix small codingstyle
From: Joe Perches <joe@perches.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, Libin <huawei.libin@huawei.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com, xiexiuqi@huawei.com
Date: Wed, 16 Oct 2013 10:17:46 -0700
In-Reply-To: <1381942237.4324.4.camel@buesod1.americas.hpqcorp.net>
References: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com>
	 <1381855484.2354.0.camel@buesod1.americas.hpqcorp.net>
	 <1381862186.22110.33.camel@joe-AO722> <525E50A6.1070206@colorfullife.com>
	 <1381942237.4324.4.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 09:50 -0700, Davidlohr Bueso wrote:
> On Wed, 2013-10-16 at 10:39 +0200, Manfred Spraul wrote:
> > Hi Joe,

Hi all.

> > Grek just sent me 47 patches for the backport to 3.10-stable, I don't 
> > want any whitespace noise right now.
> +1

Do it when it's convenient or don't do it at all.
No worries from me.

It's pretty automatic if you use checkpatch from -next.

$ scripts/checkpatch.pl -f --fix --types=pointer_location,spacing,space_before_tab ipc/*.[ch]
$ find ipc/ -name "*.EXPERIMENTAL-checkpatch-fixes" | \
  while read file ; do mv $file ${file%.EXPERIMENTAL-checkpatch-fixes}; done

The space_before_tab suggested correction currently only
removes a single space before the tab and may need to be
run multiple times.


