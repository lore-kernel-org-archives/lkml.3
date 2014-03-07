Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaCGRQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:16:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaCGRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:16:24 -0500
Message-ID: <1394212581.9487.23.camel@marge.simpson.net>
Subject: Re: [patch] rt,blk,mq: Make blk_mq_cpu_notify_lock a raw spinlock
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Fri, 07 Mar 2014 18:16:21 +0100
In-Reply-To: <20140307160002.GB18441@linutronix.de>
References: <1393822646.5816.4.camel@marge.simpson.net>
	 <20140307160002.GB18441@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:DPU0YaPTSG5b1Sj7ohfCFN74u28XeYyi/MCRGfj3S6E
 9426Dtf2BpMlQVERMyT/1aeoCpppUKg+Dm9X40PrcBds2Mhp5D
 v9dCFOrR0p7B3TUtlOi7DplamBXnL/QPkhcMnTdxAU8XsRiFPI
 J/z1lOLL6tELZgFO/WFUr3UKCPPmGwRpNOAElEScSlCH3hAtkk
 eB4C/eIA6rnFqHTsxVwrUpecUsEGPlLvDpRvfvCUwdxG4tTm5+
 B6ADuSubfoGKAMtEb0EPa0KNn4RoJd2fmTlIB8tzofBYoi9DoV
 ZRWkBSFJo2N3QqMFn6U4RqQ1OlD8cZKb18XIoPpeP83Ps74pEZ
 O+g/cn8aRTpRnf0T2lDp/DEyHdFiXml9R0jZDFgfH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 17:00 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2014-03-03 05:57:26 [+0100]:
> 
> > block/blk-mq-cpu.c |   14 +++++++-------
> 
> This got in v3.13-rc1, are you running some kind of backported version
> of this in v3.12 or do you have your own v3.13-rt?

It's 3.12, but with a few (koff) backports.

-Mike

