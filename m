Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbaJ2V7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:59:42 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:33672 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756664AbaJ2V7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:59:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3351:3622:3865:3868:3870:3872:3873:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ship90_8e56243002621
X-Filterd-Recvd-Size: 1519
Message-ID: <1414619976.2542.1.camel@perches.com>
Subject: Re: mmotm 2014-10-29-14-19 uploaded
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz
Date: Wed, 29 Oct 2014 14:59:36 -0700
In-Reply-To: <alpine.DEB.2.11.1410292233340.5308@nanos>
References: <54515a25.46WrYSce5BExT3V4%akpm@linux-foundation.org>
	 <alpine.DEB.2.11.1410292233340.5308@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 22:37 +0100, Thomas Gleixner wrote:
> On Wed, 29 Oct 2014, akpm@linux-foundation.org wrote:
> > This mmotm tree contains the following patches against 3.18-rc2:
> > (patches marked "*" will be included in linux-next)
> > 
> > * kernel-posix-timersc-code-clean-up.patch
> 
> Can you please drop this pointless churn? We really can replace all
> that stuff with a shell script and let it run over the tree every now
> and then.

Should any automated code reformatting really be done
by an unsupervised or unreviewed shell script?

Likely not.


