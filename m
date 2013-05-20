Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3ETER1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:17:27 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:47531 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3ETERY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <51991D53.7020806@gmail.com>
References: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
	<1b08f7e4657818e4a00ea7ebb137998223834dd5.1368789952.git.viresh.kumar@linaro.org>
	<51991D53.7020806@gmail.com>
Date: Mon, 20 May 2013 09:47:23 +0530
Message-ID: <CAKohponu_0j6GiWOrbHJScbwXDWoOWzeySPDdRBRowq2bGJ2Ug@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: Don't create empty /sys/devices/system/cpu/cpufreq
 directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, linux-pm@vger.kernel.org,
        patches@linaro.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Steve.Bannister@arm.com, arvind.chauhan@arm.com,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2013 00:13, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> On 05/17/2013 01:26 PM, Viresh Kumar wrote:
>> +EXPORT_SYMBOL(get_cpufreq_global_kobject);
>> +EXPORT_SYMBOL(put_cpufreq_global_kobject);
>
> Global symbol names should begin with a sensible prefix; in this case,
> it looks like cpufreq_get_global_kobject and cpufreq_put_global_kobject
> would be more appropriate names.

Sure. Thanks.
