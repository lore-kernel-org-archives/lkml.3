Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaKFA7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:59:33 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:3531 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKFA7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:59:30 -0500
Message-ID: <545AC7DE.8080602@huawei.com>
Date: Thu, 6 Nov 2014 08:59:10 +0800
From: leizhen <thunder.leizhen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH 1/1] of/fdt: simplify early_init_dt_verify
References: <1414497065-9808-1-git-send-email-thunder.leizhen@huawei.com> <20141104162054.4CC9BC423D0@trevor.secretlab.ca> <CAErSpo6Upf=QPn7=Cd=XDazXVnSPhb-9gDZjH9_CcY37-xUKLw@mail.gmail.com> <5459740B.6000906@huawei.com> <CACxGe6tkOWtqtt9nVk2R=NqsEVZBDCV-1deVhEXf1pAGS7YhFA@mail.gmail.com>
In-Reply-To: <CACxGe6tkOWtqtt9nVk2R=NqsEVZBDCV-1deVhEXf1pAGS7YhFA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/5 21:52, Grant Likely wrote:
> On Wed, Nov 5, 2014 at 12:49 AM, leizhen <thunder.leizhen@huawei.com> wrote:
>> On 2014/11/5 1:03, Bjorn Helgaas wrote:
>>> On Tue, Nov 4, 2014 at 9:20 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>>> On Tue, 28 Oct 2014 19:51:05 +0800
>>>> , Zhen Lei <thunder.leizhen@huawei.com>
>>>>  wrote:
>>>>> put off initial_boot_params = params; until all checks finished. If any check
>>>>> failed, initial_boot_params is equal NULL, base upon bss segment initial value.
>>>>>
>>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>>>
>>>> Interesting. I received exactly the same patch from Bjorn Helgaas. Were
>>>> the two of you working together, or is this merely a coincedence?
>>>
>>> LOL, that's really funny.  We're not working together, so it's a total
>>> coincidence :)
>>>
>> Haha!!!
>>
>> Hi, Bjorn Helgaas. Nice to meet you.
> 
> I've applied Bjorn's version, but since the diffstat is *identical*,
> I've put both of your s-o-b lines into it.
> 
> BTW Lei, what prompted you to write this patch? Was there a bug you
> were fixing, or did you just notice the inconsistency and decide to
> fix it?
> 
> g.
> 
> .
> 
OK

The latter case. Just found it when I reading code.

