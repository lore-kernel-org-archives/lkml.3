Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162694AbaDCIyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:54:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60104 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162578AbaDCIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:54:09 -0400
Message-ID: <533D21AF.2070508@free-electrons.com>
Date: Thu, 03 Apr 2014 10:54:07 +0200
From: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: dts: document the berlin enable-method property
References: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>	<1396512496-8030-3-git-send-email-antoine.tenart@free-electrons.com> <20140403162202.79b63729@xhacker>
In-Reply-To: <20140403162202.79b63729@xhacker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jisheng,

On 03/04/2014 10:22, Jisheng Zhang wrote:
> Hi,
>
> On Thu, 3 Apr 2014 01:08:15 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
>
>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>> ---
>>   Documentation/devicetree/bindings/arm/cpus.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt
>> b/Documentation/devicetree/bindings/arm/cpus.txt index
>> 333f4aea3029..a9e42a2dbc99 100644 ---
>> a/Documentation/devicetree/bindings/arm/cpus.txt +++
>> b/Documentation/devicetree/bindings/arm/cpus.txt @@ -185,6 +185,8 @@ nodes
>> to be present and contain the properties described below. "qcom,gcc-msm8660"
>>   			    "qcom,kpss-acc-v1"
>>   			    "qcom,kpss-acc-v2"
>> +			    "marvell,88de31-smp" - cpu-core handling for
>
> why not "marvell,berlin-smp"?

We have SMP on the BG2 and the BG2Q currently. Future boards may not be 
compatible with this method (BG3 ?), I think "marvell,berlin-smp" is too 
generic.

We could use "marvell,88de31xx-smp" as Alexandre suggested.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
