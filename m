Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3FGLWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:22:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59456 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab3FGLWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:22:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [GIT PULL RESENT] CPUFreq: ARM Updates for v3.11
Date: Fri, 07 Jun 2013 13:31:24 +0200
Message-ID: <195814068.OMscJ0xp3P@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokJt=8UpAKKEEFaojq-M_GPawrDRBdXL8erEDe2jh=Q4A@mail.gmail.com>
References: <CAKohpokJt=8UpAKKEEFaojq-M_GPawrDRBdXL8erEDe2jh=Q4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 04:39:49 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:
> 
>   Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/vireshk/linux.git cpufreq-next
> 
> for you to fetch changes up to ea61623fe9badd5a195b3a0878e6d89a2f97ac0e:
> 
>   cpufreq: kirkwood: Select CPU_FREQ_TABLE option (2013-06-07 16:33:36 +0530)

Pulled, thanks Viresh!

Rafael


> ----------------------------------------------------------------
> Arnd Bergmann (2):
>       cpufreq: SPEAr needs cpufreq table
>       cpufreq: big.LITTLE needs cpufreq table
> 
> Ezequiel Garcia (1):
>       cpufreq: kirkwood: Select CPU_FREQ_TABLE option
> 
>  drivers/cpufreq/Kconfig.arm | 3 +++
>  1 file changed, 3 insertions(+)
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
