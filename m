Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaAUIME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:12:04 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48400 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaAUIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:12:02 -0500
MIME-Version: 1.0
In-Reply-To: <630F9443351D2B4BB7EC6BAE6B6B08342549C5DC@SHSMSX104.ccr.corp.intel.com>
References: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
	<CAKohponL_R8M40BJa3X+++1yDtw5KRvk88w8kVfA+_D+poK08A@mail.gmail.com>
	<630F9443351D2B4BB7EC6BAE6B6B08342549C5DC@SHSMSX104.ccr.corp.intel.com>
Date: Tue, 21 Jan 2014 13:42:01 +0530
Message-ID: <CAKohpo=ng-B6kLdWxBn_cNsWNVsYaNAD-ZzQLLOfkbj+FDg_fg@mail.gmail.com>
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

On 21 January 2014 12:56, Li, Zhuangzhi <zhuangzhi.li@intel.com> wrote:
> Thanks for reviewing.

Its my job :)

> Sorry for make you misunderstanding, on our x86 platform, we want all the CPUs share one policy by setting CPUFREQ_SHARED_TYPE_ALL, not share one HW clock line.

I see.. Then probably your patch makes sense. But it is
obviously not required for every platform that exists today.

Please update it to do it only for drivers that have set
CPUFREQ_SHARED_TYPE_ALL..

@Rafael: I hope you agree?
