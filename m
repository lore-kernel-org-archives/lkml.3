Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaAXB7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 20:59:55 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:1685 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaAXB7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 20:59:54 -0500
Message-ID: <52E1C8BD.2010500@huawei.com>
Date: Fri, 24 Jan 2014 09:58:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, <mingo@kernel.org>,
        <peterz@infradead.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Tejun

On 2014/1/24 5:31, David Rientjes wrote:
> On Thu, 23 Jan 2014, Viresh Kumar wrote:
> 
>> update_flag() routine uses heap only when spread_flag_changed is true. Otherwise
>> heap isn't used, but is allocated and freed unnecessarily.
>>

but harmless

>> Fix this by allocating heap only when required.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Acked-by: Li Zefan <lizefan@huawei.com>

I would like this patch be picked up by Tejun. I'll send out a patchset
for cpuset which may have confliction with this one.

