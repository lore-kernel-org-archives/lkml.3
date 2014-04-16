Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040AbaDPTVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:21:32 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44350 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaDPTV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:21:29 -0400
Message-ID: <534ED833.9080004@gmail.com>
Date: Wed, 16 Apr 2014 21:21:23 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Jisheng Zhang <jszhang@marvell.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ARM: berlin: add GPIO support for the BG2Q
References: <1397634395-7456-1-git-send-email-antoine.tenart@free-electrons.com> <20140416171112.31757110@xhacker>
In-Reply-To: <20140416171112.31757110@xhacker>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 11:11 AM, Jisheng Zhang wrote:
> On Wed, 16 Apr 2014 00:46:33 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
> 
>> This series add the support for the GPIOs of the Berlin BG2Q. We use the
>> newly integrated dwapb GPIO driver here.
>>
>> This applies on top of Alexandre's BG2Q symbol introduction[1] and the dwapb
>> gpio patch fixing IRQ initialization[2].
>>
>> [1] https://patchwork.kernel.org/patch/3876141/
>> [2] https://lkml.org/lkml/2014/4/7/96
>>
>> Changes since v1:
>> 	- s/gpio-controller@/gpio-port@/ in device tree
>> 	- moved ARCH_REQUIRE_GPIOLIB to ARCH_BERLIN in Kconfig
>>
>> Antoine Ténart (2):
>>   ARM: berlin: add the LIBGPIO as a dependency for the BG2Q
>>   ARM: dts: berlin: add GPIO nodes for the BG2Q
>>
>>  arch/arm/boot/dts/berlin2q.dtsi | 102
>> ++++++++++++++++++++++++++++++++++++++++ arch/arm/mach-berlin/Kconfig
>> |   1 + 2 files changed, 103 insertions(+)
>>
> 
> All the two patches look good

Patch 1 applied to berlin/soc,
Patch 2 applied to berlin/dt,

both with Jisheng's Reviewed-by.

Thanks!

