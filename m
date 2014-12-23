Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaLWNlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:41:22 -0500
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:54654 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751186AbaLWNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:41:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:3873:3874:4321:4362:5007:6261:10004:10400:10848:11026:11232:11658:11914:12114:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smoke24_b61d9b39620b
X-Filterd-Recvd-Size: 1245
Message-ID: <1419342076.18020.9.camel@perches.com>
Subject: Re: [PATCH v2] checkpatch: fix UNNECESSARY_KERN_LEVEL false positive
From: Joe Perches <joe@perches.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 23 Dec 2014 05:41:16 -0800
In-Reply-To: <1419341485-31575-1-git-send-email-pbonzini@redhat.com>
References: <1419341485-31575-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 14:31 +0100, Paolo Bonzini wrote:
> KERN_<LEVEL> is never redundant with printk_ratelimited or printk_once.
> (Except perhaps in the sense that you could use e.g. pr_err_ratelimited
> or pr_err_once, but that would apply to printk as well).
[]
> 	v1->v2: skip printk_once too [Joe Perches]

Thanks,

Acked-by: Joe Perches <joe@perches.com>


