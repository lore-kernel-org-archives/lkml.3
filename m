Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaFMQOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:14:45 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:33172 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751393AbaFMQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:14:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3871:3872:3873:3874:4321:4605:5007:7522:7652:7875:7903:10004:10226:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SP
X-HE-Tag: boats51_b71c3f38740b
X-Filterd-Recvd-Size: 1631
Message-ID: <1402676074.12385.40.camel@joe-AO725>
Subject: Re: [PATCH V2 00/19] irqchip: crossbar: driver fixes
From: Joe Perches <joe@perches.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Date: Fri, 13 Jun 2014 09:14:34 -0700
In-Reply-To: <20140613150122.GP8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
	 <20140613150122.GP8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 11:01 -0400, Jason Cooper wrote:
> Please format the subject lines like so:
> 
>   irqchip: crossbar: Set cb pointer ...
>                      ^
>                      |
>                      \-- note the capitalization

I suggest you don't make this a rule and focus
on more important stuff instead.

Nobody is going to write tools that parse the
changelogs by "git log --format=%s" for case
sensitivity.

As is, it's about half/half.

$ git log --format=%s --no-merges drivers/irqchip/ | \
  grep "^irqchip:" | cut -f3- -d":"

