Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3CGBqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:46:20 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61708 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3CGBqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAHLZz11PR6E7-yhrxwRi=HWo9tWByH5FUArDqfXQh6N0C_x0tQ@mail.gmail.com>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
	<20130305105251.GL17833@n2100.arm.linux.org.uk>
	<CAKohpo=cBkHZnSa8ZsM=k7RRN+RZDXFUWDM82EXXBSQcM-8Vhw@mail.gmail.com>
	<CAHLZz11PR6E7-yhrxwRi=HWo9tWByH5FUArDqfXQh6N0C_x0tQ@mail.gmail.com>
Date: Thu, 7 Mar 2013 09:46:16 +0800
Message-ID: <CAKohponduoxw8KoWtCzfYgthXGmi=8=ydR4dzQOy--PXcPFfWg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, rjw@sisk.pl,
        Steve.Bannister@arm.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, robin.randhawa@arm.com,
        linux-arm-kernel@lists.infradead.org, mark.hambleton@broadcom.com,
        linaro-kernel@lists.linaro.org, charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2013 08:49, Harvey Harrison <harvey.harrison@gmail.com> wrote:
> On Wed, Mar 6, 2013 at 4:32 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
>>         clk[cluster] = clk_get_sys(name, NULL);
>> -       if (!IS_ERR(clk[cluster])) {
>> +       if (!IS_ERR_OR_NULL(clk[cluster])) {
>>                 pr_debug("%s: clk: %p & freq table: %p, cluster: %d\n",
>>                                 __func__, clk[cluster], freq_table[cluster],
>>                                 cluster);
>
>
> You seem pretty attached to IS_ERR_OR_NULL here.

Haha. Not really. I just wanted to get more logical conclusion out. Please check
the other mail (where i would reply to Russell), which might have more
discussion
around this.
