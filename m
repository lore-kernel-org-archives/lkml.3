Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3BVMfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:35:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41415 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab3BVMfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:35:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Cc: Nishanth Menon <nm@ti.com>, Wei Yongjun <weiyj.lk@gmail.com>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / devfreq: fix missing unlock on error in exynos4_busfreq_pm_notifier_event()
Date: Fri, 22 Feb 2013 13:41:51 +0100
Message-ID: <11191890.8oYqJ4b1Vm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2946170.20251361514836501.JavaMail.weblogic@epml14>
References: <2946170.20251361514836501.JavaMail.weblogic@epml14>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 06:33:58 AM MyungJoo Ham wrote:
> > On 12:33-20130222, Wei Yongjun wrote:
> > > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > 
> > > Add the missing unlock before return from function
> > > exynos4_busfreq_pm_notifier_event() in the error
> > > handling case.
> > > 
> > > This issue introduced by commit 8fa938
> > > (PM / devfreq: exynos4_bus: honor RCU lock usage)
> > > 
> > > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > Arrgh.. Thanks for catching this :( My bad.
> > 
> > Fix looks good to me. upto  MyungJoo.
> 
> Applied to devfreq repository.
> I'll send pull request to Rafael soon along with other patches.
> 
> > 
> > MyungJoo, Rafael,
> > btw, adding linux-pm@vger.kernel.org to  MAINTAINERS for devfreq might
> > be a nice idea to have right audience.
> 
> It appears that replacing the current mailing list address with linux-pm is
> appropriate. If no one objects, I'll post the suggestion later.

Sure, please do.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
