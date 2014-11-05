Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaKENwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:52:31 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:43288 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKENw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:52:28 -0500
MIME-Version: 1.0
In-Reply-To: <5459740B.6000906@huawei.com>
References: <1414497065-9808-1-git-send-email-thunder.leizhen@huawei.com>
 <20141104162054.4CC9BC423D0@trevor.secretlab.ca> <CAErSpo6Upf=QPn7=Cd=XDazXVnSPhb-9gDZjH9_CcY37-xUKLw@mail.gmail.com>
 <5459740B.6000906@huawei.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 5 Nov 2014 13:52:07 +0000
X-Google-Sender-Auth: oQpUfccOXkph5c87TML1mQ7O3mk
Message-ID: <CACxGe6tkOWtqtt9nVk2R=NqsEVZBDCV-1deVhEXf1pAGS7YhFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] of/fdt: simplify early_init_dt_verify
To: leizhen <thunder.leizhen@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 12:49 AM, leizhen <thunder.leizhen@huawei.com> wrote:
> On 2014/11/5 1:03, Bjorn Helgaas wrote:
>> On Tue, Nov 4, 2014 at 9:20 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>> On Tue, 28 Oct 2014 19:51:05 +0800
>>> , Zhen Lei <thunder.leizhen@huawei.com>
>>>  wrote:
>>>> put off initial_boot_params = params; until all checks finished. If any check
>>>> failed, initial_boot_params is equal NULL, base upon bss segment initial value.
>>>>
>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>>
>>> Interesting. I received exactly the same patch from Bjorn Helgaas. Were
>>> the two of you working together, or is this merely a coincedence?
>>
>> LOL, that's really funny.  We're not working together, so it's a total
>> coincidence :)
>>
> Haha!!!
>
> Hi, Bjorn Helgaas. Nice to meet you.

I've applied Bjorn's version, but since the diffstat is *identical*,
I've put both of your s-o-b lines into it.

BTW Lei, what prompted you to write this patch? Was there a bug you
were fixing, or did you just notice the inconsistency and decide to
fix it?

g.
