Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233Ab3DDOsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:48:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203Ab3DDOsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:48:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 18/18] cpufreq: powerpc/platforms/cell: move cpufreq driver to drivers/cpufreq
Date: Thu, 4 Apr 2013 14:48:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1365079581.git.viresh.kumar@linaro.org> <201304041302.09995.arnd@arndb.de> <CAKohpok_ftPoME0tFRMWMM9A2mNSOpQSvbJut0=AzhCuB-Yjrg@mail.gmail.com>
In-Reply-To: <CAKohpok_ftPoME0tFRMWMM9A2mNSOpQSvbJut0=AzhCuB-Yjrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304041448.11052.arnd@arndb.de>
X-Provags-ID: V02:K0:NyqUvWax1PbGadlsMI20/prPzt+nP7GPC3O2yVJVup2
 9+K0ikpFUUs9EhK5ajo2LlEnrORidLYpJ2OiOxR4rjvHb70NqT
 pPiph+8rmWpictlfB5VuAhezTELLWWu/TeEvWv738GQscjbI7y
 Or0gRXpgMohxIVnaPyGlDJhv2valMi6Ez2m3MQ3jFuYdo8wO+O
 XZN2gXS1l8pbrDtobrBWYv/v9OmPVcwvtsgxeqBkuI1Zmk42cX
 Ut3ugcCRqO8kL2JBhjEng8YHmBKSITA91ZshzfmjRon9tIz/I3
 duA9jtD4q/XY3tc40/e7RcXPYsOB3GTRWqXQseV9LJg62OscQ1
 xqPt6zIgHkmhDVWBjiJU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 April 2013, Viresh Kumar wrote:
> 
> On 4 April 2013 18:32, Arnd Bergmann <arnd@arndb.de> wrote:
> > Moving the files is good, but I don't see a reason to make the cbe_cpufreq.h
> > header globally visible in include/linux/. Isn't it just used by as the
> > interface between ppc_cbe_cpufreq_pmi.c  and ppc_cbe_cpufreq.c?
> 
> When i moved it initially i thought it is also used by
> arch/powerpc/platforms/cell/cpufreq_spudemand.c and hence moved it
> to include/linux and never realized i am wrong..
> 
> Here is the fixup (And attached complete patch: original+fixup for Rafael
> to apply):


Acked-by: Arnd Bergmann <arnd@arndb.de>
