Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3JUJYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:24:18 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:62681 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3JUJX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131018154644.GC25034@n2100.arm.linux.org.uk>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
	<fb85256f34e1a61c6c2c37c3e6fa8b1398bad683.1382104515.git.viresh.kumar@linaro.org>
	<20131018154644.GC25034@n2100.arm.linux.org.uk>
Date: Mon, 21 Oct 2013 14:53:57 +0530
Message-ID: <CAKohpok-wy7FnGfyVTp2whrDZuezh2okA+FXVWqwg5wc8bBM9w@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 29/34] cpufreq: sa11x0: Convert to light weight
 ->target_index() routine
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2013 21:16, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Oct 18, 2013 at 07:29:52PM +0530, Viresh Kumar wrote:
>> This patch converts existing .target() to newly defined light weight
>> .target_index() routine for this driver.
>>
>> CPUFreq core will call cpufreq_frequency_table_target() before calling this
>> routine and will pass index to it.
>>
>> Some existing routines are no more required and so are removed now.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>
> I think I acked this patch.  Please ensure that my ack appears on all
> that I did ack, thanks.

Yeah. I am sure you did Ack it and I applied your Ack in one of my branches.
But somehow I screwed up and only your Ack was missing in the patches
I sent.. Others weren't missed.

Will handle this along with Rafael and will not miss any of your Acks.

Thanks..
