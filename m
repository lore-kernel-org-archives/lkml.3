Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaDHBBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:01:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61668 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbaDHBBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:01:12 -0400
Message-ID: <53434A4E.2050407@gmail.com>
Date: Tue, 08 Apr 2014 09:01:02 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drivers:cpufreq:unicore32: fix typo issue for 'clk'
References: <53429445.5000005@gmail.com> <CAKohpok189SxuJoGNvgshwEaUozMDM9mzA8wse5COkN8MBUaPg@mail.gmail.com>
In-Reply-To: <CAKohpok189SxuJoGNvgshwEaUozMDM9mzA8wse5COkN8MBUaPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 08:08 PM, Viresh Kumar wrote:
> On 7 April 2014 17:34, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> Need use 'clk' instead of 'mclk', which is the original removed local
>> variable.
>>
>> The related original commit:
>>
>>   "652ed95 cpufreq: introduce cpufreq_generic_get() routine"
>>
>> The related error with allmodconfig for unicore32:
>>
>>     CC      drivers/cpufreq/unicore2-cpufreq.o
>>   drivers/cpufreq/unicore2-cpufreq.c: In function 'ucv2_target':
>>   drivers/cpufreq/unicore2-cpufreq.c:48: error: 'struct cpufreq_policy' has no member named 'mclk'
>>   make[2]: *** [drivers/cpufreq/unicore2-cpufreq.o] Error 1
>>   make[1]: *** [drivers/cpufreq] Error 2
>>   make: *** [drivers] Error 2
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  drivers/cpufreq/unicore2-cpufreq.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Stupid mistake.
> 

It is very easy to lead other members to make mistakes, or let ourself
make mistakes.

> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> @stable: please apply this for v3.14, as it broke in that cycle..
> 

Thank you.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
