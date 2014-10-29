Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbaJ2PDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:03:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47178 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbaJ2PDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:03:16 -0400
Message-ID: <5451019C.8080604@ti.com>
Date: Wed, 29 Oct 2014 11:02:52 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Enable PCI controller for Keystone SoCs
References: <1414173095-32511-1-git-send-email-m-karicheri2@ti.com> <544FBF1C.80305@ti.com> <544FBF4D.6000502@ti.com> <544FC540.1050501@gmail.com>
In-Reply-To: <544FC540.1050501@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 12:33 PM, Santosh Shilimkar wrote:
>
>
> On 10/28/2014 09:07 AM, Murali Karicheri wrote:
>> On 10/28/2014 12:06 PM, Murali Karicheri wrote:
>>> On 10/24/2014 01:51 PM, Murali Karicheri wrote:
>>>> Now that Keystone PCI driver is merged to v3.18, this patch series
>>>> add build options and DTS bindings to enable the driver for Keystone
>>>> SoCs.
>>>>
>>>> CC : Santosh Shilimkar<santosh.shilimkar@gmail.com>
>>>> CC : Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>>> CC : Rob Herring<robh+dt@kernel.org>
>>>> CC : Pawel Moll<pawel.moll@arm.com>
>>>> CC : Mark Rutland<mark.rutland@arm.com>
>>>> CC : Ian Campbell<ijc+devicetree@hellion.org.uk>
>>>> CC : Kumar Gala<galak@codeaurora.org>
>>>> CC : Russell King<linux@arm.linux.org.uk>
>>>> CC : devicetree@vger.kernel.org
>>>>
>>>> Murali Karicheri (4):
>>>> ARM: keystone: add pcie related options
>>>> ARM: keystone: defconfig: add options to enable PCI controller
>>>> ARM: keystone: dts: add DT bindings for PCI controller for port 0
>>>> ARM: keystone: dts: add DT bindings for PCI controller for port 1
>>>>
>>>> arch/arm/boot/dts/k2e.dtsi | 45 +++++++++++++++++++++++++++++++++++
>>>> arch/arm/boot/dts/keystone.dtsi | 45 
>>>> +++++++++++++++++++++++++++++++++++
>>>> arch/arm/configs/keystone_defconfig | 3 +++
>>>> arch/arm/mach-keystone/Kconfig | 2 ++
>>>> 4 files changed, 95 insertions(+)
>>>>
>>> Santosh,
>>>
>>> Could you review this and apply to your tree for merge by end of this
>>> week if this looks good and there are no comments?
>>>
>> Adding Santosh's personal email ID
>>
> Just use the listed kernel.org id while posting patches which needs
> my attention. Please repost the series again so that I have all the
> patches.
Will do
>
> Also what happened with the PCIE notifier related series ?
> If you have already proposed something, please loop me on the thread.
>
That is work in progress. I have got something working, but dma-ranges 
are also used in a different
way by the PCI sub systems on Power PC and require more thought on how 
this can be done cleanly.
I am investigating this currently.
> Thanks and Regards,
> Santosh


-- 
Murali Karicheri
Linux Kernel, Texas Instruments

