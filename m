Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaIOQC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:02:28 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:59142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751752AbaIOQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:02:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3871:3872:4321:5007:7652:8660:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13148:13161:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: magic17_87da0905ab836
X-Filterd-Recvd-Size: 1659
Message-ID: <1410796932.18787.7.camel@joe-AO725>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Sep 2014 09:02:12 -0700
In-Reply-To: <20140915155656.GA29744@arm.com>
References: <cover.1410632834.git.joe@perches.com>
	 <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
	 <20140915155656.GA29744@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 16:56 +0100, Will Deacon wrote:
> On Sat, Sep 13, 2014 at 07:31:12PM +0100, Joe Perches wrote:
> > Use the more common pr_warn.
[]
> It's Russell's call on this, but it really looks like more trouble than it's
> worth imo. Having git blame identify the person who wrote the original code
> is considerably more useful than being pointed at somebody making cosmetic
> changes.

The general idea is to standardize the printk mechanisms
and eventually remove pr_warning.


