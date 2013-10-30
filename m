Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3J3QHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:07:50 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:58311 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751553Ab3J3QHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:07:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:3871:3873:4321:5007:6120:7652:9010:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cap71_26dbb8113be0a
X-Filterd-Recvd-Size: 1482
Message-ID: <1383149265.9435.19.camel@joe-AO722>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
From: Joe Perches <joe@perches.com>
To: James Hogan <james.hogan@imgtec.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 30 Oct 2013 09:07:45 -0700
In-Reply-To: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 10:18 +0000, James Hogan wrote:
> Commit 3e39c1ab04ba (printk: mark printk_once test variable
> __read_mostly) added __read_mostly to the __print_once bool in the
> printk_once() macro, but __read_mostly is defined in <linux/cache.h>
> which isn't included from <linux/printk.h>. This results in build errors
> like this:
> 
> arch/metag/mm/l2cache.c: In function 'meta_l2c_setup':
> arch/metag/mm/l2cache.c:56: error: '__read_mostly' undeclared

Fengguang?

Do you have the metag arch cross-compiler in your auto build tests?

Is there a list somewhere of what arches are build tested?

cheers, Joe

