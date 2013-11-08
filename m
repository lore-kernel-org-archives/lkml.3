Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3KHErx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:47:53 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60135 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3KHErs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <4433736.xh14GOaN7a@vostro.rjw.lan>
References: <1383791330-8289-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
	<4433736.xh14GOaN7a@vostro.rjw.lan>
Date: Fri, 8 Nov 2013 10:17:46 +0530
Message-ID: <CAKohpo=Fm+_8nOnZAE_kDu8p7NgaAQY_-rvoxsHo+d3EQyvBOA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: conservative: fix requested_freq reduction issue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 00:27, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, November 07, 2013 10:39:38 AM Viresh Kumar wrote:

>> We need another patch for fixing the other part of code where we
>> increase freq..
>> We need to replace:
>>
>> if (dbs_info->requested_freq == policy->max)
>>     return;
>>
>> with
>>
>> if (dbs_info->requested_freq >= policy->max)
>>     return;
>>
>> So, that we don't run unnecessary code :)
>
> Care to prepare a patch?

I wanted to give a chance to Xiaoguang to generate a patch for us :)
Lets wait for his reply, otherwise I will do it.
