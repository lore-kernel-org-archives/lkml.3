Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3HMTux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:50:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41467 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab3HMTuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:50:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] cpufreq: sa11x0: cleanups for 3.13
Date: Tue, 13 Aug 2013 22:01:17 +0200
Message-ID: <1437762.edDpfxPldn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1376392060.git.viresh.kumar@linaro.org>
References: <cover.1376392060.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 13, 2013 07:01:04 PM Viresh Kumar wrote:
> Hi Rafael/Russell,
> 
> These patches would be part of this patchset finally, sending it separately as I
> didn't wanted to send other patches in that series..
> 
> https://lkml.org/lkml/2013/8/10/48
> 
> (Above series was rebased over https://lkml.org/lkml/2013/8/8/263 and hence this
> patchset too)..
> 
> These first exposes frequency table and then uses cpufreq generic routines
> (which uses exposed table) instead of its own .verify() routine.
> 
> Later I will send another patch that would be part of this series:
> 
> http://lkml.org/lkml/2013/8/12/406
> 
> (I need to send that series again today and so not sending that patch twice,
> once here and then in that series)..
> 
> All these patches are pushed here with all dependencies:
> 
> https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

Are the three patches in this series prerequisite for the big target_index
one?  If so, I think they can go into 3.12 actually, if they are ACKed by the
appropriate platform maintainers.

> Viresh Kumar (3):
>   cpufreq: sa11x0: Expose frequency table
>   cpufreq: sa11x0: let cpufreq core initialize struct policy fields
>   cpufreq: sa11x0: Use generic cpufreq routines
> 
>  arch/arm/mach-sa1100/generic.c   | 65 +++++++++++++---------------------------
>  arch/arm/mach-sa1100/generic.h   |  2 +-
>  drivers/cpufreq/sa1100-cpufreq.c |  9 +++---
>  drivers/cpufreq/sa1110-cpufreq.c |  9 +++---
>  4 files changed, 30 insertions(+), 55 deletions(-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
