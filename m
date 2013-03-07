Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3CGC36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:29:58 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36551 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab3CGC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMiOBxEHVgkr=K_4JVQ6+0Swy1uRmHaS8QwRxTJKs3J2Ow@mail.gmail.com>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
	<20130307014657.GA7426@quad.lixom.net>
	<CAOesGMiOBxEHVgkr=K_4JVQ6+0Swy1uRmHaS8QwRxTJKs3J2Ow@mail.gmail.com>
Date: Thu, 7 Mar 2013 10:29:54 +0800
Message-ID: <CAKohpo=sF3nEnA4Jgr3gx-vxJTeqp6P1JmoiU=tN-bS6VJQ4Fw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-kernel@lists.linaro.org,
        mark.hambleton@broadcom.com, linux-arm-kernel@lists.infradead.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2013 09:50, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Mar 6, 2013 at 5:46 PM, Olof Johansson <olof@lixom.net> wrote:
>
>> This binding makes no sense to me. It needs to be substantially better
>> documented, not just a couple of sentences that people that understand
>> bit.LITTLE thoroughly can make sense of.
>>
>> It also duplicates the cpu binding. I suspect this should instead be done
>> through additions of the cpu bindings instead of duplication. So this needs to
>> be substantially reworked.

Actually, i wasn't getting in new bindings for cpu/cluster for big
LITTLE but was
just trying to get bindings for getting freq-table for cpufreq driver.

Lorenzo (cc'd) actually has a patch for getting the bindings in and he
is looking
to send them soon. I know these can change after some review and the plan was
i will fix cpufreq bindings again once that patch is in. We don't have
any mainlined
hardware for it for now and so it wouldn't break anything.

> Also, _ALWAYS_ cc devicetree-discuss on new bindings. get_maintainer
> tells you to do so.

I knew it and i messed up with it. Will surely take care of it next time.
