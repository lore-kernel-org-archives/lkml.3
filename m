Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaKJGRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:17:21 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15059 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaKJGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:17:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 09 Nov 2014 22:17:44 -0800
Message-ID: <54605898.3020402@nvidia.com>
Date: Mon, 10 Nov 2014 14:18:00 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>, Dylan Reid <dgreid@google.com>,
        <olofj@chromium.org>
Subject: Re: [PATCH] cpufreq: respect the min/max settings from user space
References: <1412232900-11238-1-git-send-email-vinceh@nvidia.com>	<CAKohpon=dwc--SSbwjREdrALfXH=7QCw8UJnyVX5x3TCKB=7Bw@mail.gmail.com>	<54321F90.2010103@nvidia.com>	<544F0C8C.3090003@nvidia.com> <CAKohpo=jZAmqvdYr+0uUY8xBi5bK0isADS4o5xsaK+rxALcVHQ@mail.gmail.com>
In-Reply-To: <CAKohpo=jZAmqvdYr+0uUY8xBi5bK0isADS4o5xsaK+rxALcVHQ@mail.gmail.com>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: DRBGMAIL103.nvidia.com (10.18.16.22) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Just sent v2 with your ACK. :)

Hi Rafael,

Could you please apply the v2? Thanks!

Vince

On 11/10/2014 01:09 PM, Viresh Kumar wrote:
> On 28 October 2014 08:55, Vince Hsu <vinceh@nvidia.com> wrote:
>> Hi Viresh,
>>
>> Could you remind me where can I find this patch upstream? It seems this was
>> missed?
> Rafael hasn't picked it up. You can normally look at the tree Rafael
> manages:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
>
> Can you please resend it to Rafael ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

