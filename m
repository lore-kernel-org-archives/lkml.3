Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaIPQSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:18:07 -0400
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:50233 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754583AbaIPQSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:18:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3870:3871:3872:3873:4321:5007:7652:8957:10004:10400:10848:11658:11914:12517:12519:12740:13069:13095:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: snail61_292ac598e2525
X-Filterd-Recvd-Size: 1611
Message-ID: <1410884281.16519.2.camel@joe-AO725>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 16 Sep 2014 09:18:01 -0700
In-Reply-To: <20140916160759.GJ12361@n2100.arm.linux.org.uk>
References: <cover.1410632834.git.joe@perches.com>
	 <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
	 <20140915155656.GA29744@arm.com>
	 <20140916160759.GJ12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 17:07 +0100, Russell King - ARM Linux wrote:
> any chance you could add a KernelVersion: tag somewhere in the
> commit message and throw it at patches@arm.linux.org.uk so it doesn't
> get lost?

There are no commit logs with a KernelVersion: tag
in all of git history.

What do you think a KernelVersion: tag is and what
would it be used for?


