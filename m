Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966Ab3FTTy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:54:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44617 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965319Ab3FTTyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:54:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Date: Thu, 20 Jun 2013 22:03:45 +0200
Message-ID: <5038475.Kzi1Kavss7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=5ZJp6JBVVA0NinTMO5FUwtfy3QAabcTwVOW6TmEfs9g@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1371661969-7660-3-git-send-email-l.majewski@samsung.com> <CAKohpo=5ZJp6JBVVA0NinTMO5FUwtfy3QAabcTwVOW6TmEfs9g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 20, 2013 10:43:08 AM Viresh Kumar wrote:
> On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> 
> > Boost sysfs attribute is always exported (to support legacy API). By
> > default boost is exported as read only. One global attribute is available at:
> > /sys/devices/system/cpu/cpufreq/boost.
> 
> You asked me and Rafael a question and posted your next version without
> even waiting for our replies? That will waste your time and ours too
> reviewing it.

I believe I replied to that (in a different branch of the thread).

And the reply was: Do not expose if not supported.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
