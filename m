Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3ISW0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:26:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55273 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3ISW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:26:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
Date: Fri, 20 Sep 2013 00:37:50 +0200
Message-ID: <11319698.mBBnJVdnIk@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomt+sASL=2i-v=HSkhOZhbPmnFesEfPoEqSE+WKcCfnmw@mail.gmail.com>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org> <CAKohpomt+sASL=2i-v=HSkhOZhbPmnFesEfPoEqSE+WKcCfnmw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 19, 2013 09:38:32 AM Viresh Kumar wrote:
> On 19 September 2013 09:35, Yinghai Lu <yinghai@kernel.org> wrote:
> > System that cpu support intel_pstate, acpi_cpufreq fail to
> > load, and udev keep trying until trace get filled up and
> > kernel crash.
> >
> > The root cause is driver return ret from cpufreq_register_driver
> > and when some other driver take over before, it would return
> > EBUSY, then udev will keep trying...
> >
> > cpufreq_register_driver should return EEXIST instead.
> > then system could boot without appending intel_pstate=disable
> > and still use intel_pstate.
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
