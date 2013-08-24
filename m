Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3HXTdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 15:33:03 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57483 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab3HXTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 15:33:00 -0400
Message-ID: <52190A72.4070407@cogentembedded.com>
Date: Sat, 24 Aug 2013 23:33:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Benoit Cousson <bcousson@baylibre.com>, tony@atomide.com,
        devicetree@vger.kernel.org, Matt Porter <matt@ohporter.com>,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: add AM33XX EDMA support
References: <1377284808-32412-1-git-send-email-bigeasy@linutronix.de> <5218F519.3040409@cogentembedded.com> <5218FC6C.6000002@ti.com>
In-Reply-To: <5218FC6C.6000002@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/24/2013 10:33 PM, Joel Fernandes wrote:

> Updating CC with Matt's current email address.

>>> From: Matt Porter <mdp@ti.com>

>>> Adds AM33XX EDMA support to the am33xx.dtsi as documented in
>>> Documentation/devicetree/bindings/dma/ti-edma.txt

>>> Joel: Drop DT entries that are non-hardware-description for now as discussed
>>> in [1]

>>> [1] https://patchwork.kernel.org/patch/2226761/

>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>> ---
>>> Could someone please pick this up?

>>>    arch/arm/boot/dts/am33xx.dtsi | 12 ++++++++++++
>>>    1 file changed, 12 insertions(+)

>>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>>> index 38b446b..784f774 100644
>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>> @@ -96,6 +96,18 @@
>>>                reg = <0x48200000 0x1000>;
>>>            };
>>>
>>> +        edma: edma@49000000 {

>>     The node should be named "dma-controller", not "edma",according to ePAPR
>> section 2.2.2:

>> http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

> So you mean something like the following?

> edma: dma-controller@49000000 {
>    ...
> }

    Yes, exactly.

> Thanks,

> -Joel

WBR, Sergei

