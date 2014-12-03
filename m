Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaLCJLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:11:41 -0500
Received: from mout.web.de ([212.227.15.3]:63871 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaLCJLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:11:39 -0500
Message-ID: <547ED391.1050507@users.sourceforge.net>
Date: Wed, 03 Dec 2014 10:10:41 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: ARM: DaVinci: Deletion of an unnecessary check before the function
 call "__clk_disable"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547EC6B8.6000001@users.sourceforge.net>
In-Reply-To: <547EC6B8.6000001@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ZRW62UWrEgR4QCZ5VC9osnBSaczgVh+8cs9Qp0Zj7OdBTtuL16T
 R7YDT1iHM7Mgg74QTEbITrSn1w057klHuDOxumPPzDkduZjmlYa6VlogBH0RPfNsvYiSlTX
 P8DjWLvqfP5owFjJh6vI82/A7fmnn59GdMP7MolaWRXNVvL3uyqQx22Yx1QBK+YtEDZFCqp
 pavtNihmXfSZd6tQaPBhw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The __clk_disable() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

I was a bit too quick to send you this notification. I stumbled once more
on the detail that my source code analysis approach is incomplete for
static functions so far.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/mach-davinci/clock.c?id=a7ca2bcf2d2ef15c343a12f2a4c2e06380a0f495#n47
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/clk/clk.c?id=4dc7ed32f398fa76b9e1d243a852420b1dad0150#n846

I would like to apologise for confusion I introduced here.

Regards,
Markus

