Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaAVFSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:18:37 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:54906 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaAVFSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=ng-B6kLdWxBn_cNsWNVsYaNAD-ZzQLLOfkbj+FDg_fg@mail.gmail.com>
References: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
	<CAKohponL_R8M40BJa3X+++1yDtw5KRvk88w8kVfA+_D+poK08A@mail.gmail.com>
	<630F9443351D2B4BB7EC6BAE6B6B08342549C5DC@SHSMSX104.ccr.corp.intel.com>
	<CAKohpo=ng-B6kLdWxBn_cNsWNVsYaNAD-ZzQLLOfkbj+FDg_fg@mail.gmail.com>
Date: Wed, 22 Jan 2014 10:48:27 +0530
Message-ID: <CAKohpokHi=yuGJm2Nf-TAMVhGQ8Do02j+s6z3eenKRzoW8pv7g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Align all CPUs to the same frequency if using
 shared clock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2014 13:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 21 January 2014 12:56, Li, Zhuangzhi <zhuangzhi.li@intel.com> wrote:
>> Thanks for reviewing.
>
> Its my job :)
>
>> Sorry for make you misunderstanding, on our x86 platform, we want all the CPUs share one policy by setting CPUFREQ_SHARED_TYPE_ALL, not share one HW clock line.
>
> I see.. Then probably your patch makes sense. But it is
> obviously not required for every platform that exists today.
>
> Please update it to do it only for drivers that have set
> CPUFREQ_SHARED_TYPE_ALL..

One more thing, who has set different frequencies to these cores?
I hope kernel hasn't ?

In that case, probably you are fixing a bootloader bug in kernel?
What about doing this in bootloader then?

--
virehs
