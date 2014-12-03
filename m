Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaLCFtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:49:39 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:32120 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLCFti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:49:38 -0500
Message-ID: <547EA45F.6060600@huawei.com>
Date: Wed, 3 Dec 2014 13:49:19 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH 0/2] fix some problems for cpufreq
References: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com>	<2248504.pAVebap2qN@vostro.rjw.lan>	<547923F2.6000701@huawei.com>	<4004530.x5fm24OG42@vostro.rjw.lan>	<547AD41F.7030907@huawei.com> <CAKohpomMWj8QRW5eYdTGXT+HEZpSA6AV5C6mUzYyC1N1fWV7vg@mail.gmail.com>
In-Reply-To: <CAKohpomMWj8QRW5eYdTGXT+HEZpSA6AV5C6mUzYyC1N1fWV7vg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/2 12:38, Viresh Kumar wrote:
> On 30 November 2014 at 13:53, Wang Weidong <wangweidong1@huawei.com> wrote:
>> No, there are not utilities and scripts relying on it.
> 
> How can you be so sure about it ? There might be scripts/utils you
> aren't aware of
> and are depending on this..
> 
>> I just confuse that:
>> If the policy->min and policy-max is changed while it shows all available freqs
>> though scaling_available_frequencies. I can't set all freq-steps, only [policy->min, policy->max].
>> why should it show all the available freqs.
> 
> That's not the only purpose of those frequencies there. It shows list
> of all possible
> frequencies. Now, there can be issues if those lists are updated.
> 
> Suppose somebody just played with the min/max frequency, now how would anybody
> come to know about the frequencies available above/below the
> user-max/min frequency?
> 
> So as you mentioned in your example above: User space would never know about
> 
> 1.05 Ghz and 2.3GHz anymore.. Unless you remember it or save it somewhere.
> 

Nice, Thanks for your reply.

Got it.

Wang,
Regards

>> Although, it doesn't impact on us. So just ignore the patch#2. :)
> 
> Probably yes.
> 
> 


